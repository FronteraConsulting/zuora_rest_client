require 'zuora_rest_client/result'
require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'
require 'multi_json'
require 'ostruct'
require 'logger'
require 'nori'
require 'net/http'
require 'addressable/uri'

module ZuoraRestClient
  class Connection

    DEFAULT_OPTIONS = {
        entity_id: nil,
        entity_name: nil,
        logger: Logger.new($stdout),
        log_level: :error,
        log: true,
        api_proxy_port: nil }

    def initialize(username, password, environment = :production, options = {})
      @username = username
      @password = password
      @environment = environment
      @options = {}.merge(DEFAULT_OPTIONS).merge(options)
    end

    def app_get(path)
      response = app_connection.get do |request|
        request.url path
        request.headers = app_headers
      end
      process_response(response)
    end

    def app_post(path, post_data = nil, is_json = true)
      response = app_connection.post do |request|
        request.url path
        request.headers = app_headers
        request.body = MultiJson.dump(post_data) if !post_data.nil? && is_json
        request.body = post_data if !post_data.nil? && !is_json
      end
      process_response(response)
    end

    def rest_get(path, zuora_version = nil)
      response = rest_connection(use_api_proxy?(path)).get do |request|
        request.url [ ZUORA_REST_MAJOR_VERSION, path ].join('/')
        request.headers = rest_headers(zuora_version)
      end
      process_response(response)
    end

    def rest_streamed_get(path, destination_io, zuora_version = nil)

      # Set IO to binary mode
      destination_io.binmode

      endpoint_uri = Addressable::URI.parse(zuora_endpoint.rest)
      Net::HTTP.start(endpoint_uri.normalized_host, endpoint_uri.normalized_port,
          use_ssl: endpoint_uri.normalized_scheme == 'https') do |http|
        request = Net::HTTP::Get.new [ endpoint_uri.normalized_path, ZUORA_REST_MAJOR_VERSION, path ].join('/')
        rest_headers(zuora_version).each_pair do |header_key, header_value|
          request[header_key] = header_value
        end
        http.request request do |response|
          response.read_body do |chunk|
            destination_io.write chunk
          end
        end
      end

      # Set pointer to beginning of file
      destination_io.rewind

      nil
    end

    def rest_post(path, post_data = nil, zuora_version = nil, is_json = true)
      response = rest_connection(use_api_proxy?(path)).post do |request|
        request.url [ ZUORA_REST_MAJOR_VERSION, path ].join('/')
        request.headers = rest_headers(zuora_version)
        request.body = MultiJson.dump(post_data) if !post_data.nil? && is_json
        request.body = post_data if !post_data.nil? && !is_json
      end
      process_response(response)
    end

    def rest_put(path, put_data = nil, zuora_version = nil, is_json = true)
      response = rest_connection(use_api_proxy?(path)).put do |request|
        request.url [ ZUORA_REST_MAJOR_VERSION, path ].join('/')
        request.headers = rest_headers(zuora_version)
        request.body = MultiJson.dump(put_data) if !put_data.nil? && is_json
        request.body = put_data if !put_data.nil? && !is_json
      end
      process_response(response)
    end

    def rest_delete(path, zuora_version = nil)
      response = rest_connection(use_api_proxy?(path)).delete do |request|
        request.url [ ZUORA_REST_MAJOR_VERSION, path ].join('/')
        request.headers = rest_headers(zuora_version)
      end
      process_response(response)
    end

    private

    ZUORA_REST_MAJOR_VERSION = 'v1'

    ZUORA_ENVIRONMENTS = {
        production: {
            rest: 'https://rest.zuora.com',
            app: 'https://www.zuora.com' },
        api_sandbox: {
            rest: 'https://rest.apisandbox.zuora.com',
            app: 'https://apisandbox.zuora.com' } }

    def app_connection
      Faraday.new(url: zuora_endpoint.app) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.use Faraday::Request::BasicAuthentication, @username, @password
        faraday.request :multipart
        faraday.response :detailed_logger, logger
        faraday.adapter :httpclient
      end
    end

    def app_headers
      headers = { 'Content-Type' => 'application/json' }
      headers['entityId'] = @options[:entity_id] if !@options[:entity_id].nil?
      headers['entityName'] = @options[:entity_name] if !@options[:entity_name].nil?
      headers
    end

    def logger
      result = @options[:logger] || Logger.new($stdout)
      log_level = (@options[:log_level] || :info).to_s.upcase
      result.level = Logger::INFO
      result.level = Logger.const_get(log_level) if Logger.const_defined?(log_level)
      result
    end

    def process_response(response)
      if response.headers['Content-Type'].to_s.start_with?('application/json')
        hash = MultiJson.load(response.body)
        Result.new(hash.merge(response_headers(response)), recurse_over_arrays: true)
      elsif response.headers['Content-Type'].to_s.start_with?('text/xml')
        Result.new(Nori.new.parse(response.body), recurse_over_arrays: true)
      else
        response
      end
    end

    def response_headers(response)
      {response_status: response.status,
       response_headers: response.response_headers,
       reason_phrase: response.reason_phrase}
    end

    def rest_connection(use_api_proxy = false)
      rest_endpoint_uri = Addressable::URI.parse(zuora_endpoint.rest)
      if use_api_proxy
        rest_endpoint_uri.path = '/'
        rest_endpoint_uri.port = @options[:api_proxy_port] || 443
      end
      Faraday.new(url: rest_endpoint_uri.to_s) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.request :multipart
        faraday.response :detailed_logger, logger
        faraday.adapter :httpclient
      end
    end

    def rest_headers(zuora_version = nil)
      headers = { 'Content-Type' => 'application/json',
          'apiAccessKeyId' => @username,
          'apiSecretAccessKey' => @password }
      headers['entityId'] = @options[:entity_id] if !@options[:entity_id].nil?
      headers['entityName'] = @options[:entity_name] if !@options[:entity_name].nil?
      headers['zuora-version'] = zuora_version if !zuora_version.nil?
      headers
    end

    def use_api_proxy?(path)
      @environment.to_s.start_with?('services') &&
          (path.start_with?('/action/') || path.start_with?('/object/'))
    end

    def zuora_endpoint
      if @environment.is_a? Symbol
        if @environment.to_s.start_with?('services')
          rest_endpoint = "https://#{@environment.to_s}.zuora.com/apps"
          app_endpoint = "https://#{@environment.to_s}.zuora.com/apps/api"
        else
          rest_endpoint = "#{ZUORA_ENVIRONMENTS[@environment][:rest]}"
          app_endpoint = "#{ZUORA_ENVIRONMENTS[@environment][:app]}/apps/api"
        end
      elsif @environment.is_a? Hash
        rest_endpoint = "#{@environment[:rest]}"
        app_endpoint = "#{@environment[:app]}/apps/api"
      else
        raise 'Possible values for environment are: :production, :api_sandbox, :servicesNNN or a hash with base URL values for :rest and :app.'
      end
      OpenStruct.new({ rest: rest_endpoint, app: app_endpoint })
    end

  end
end