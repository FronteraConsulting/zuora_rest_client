require 'dotenv'
Dotenv.load

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zuora_rest_client'
require 'vcr'
require 'http-cookie'

RSpec.configure do |config|
  # some (optional) config here
end

$test_account_id_1 = nil
$test_account_id_2 = nil
$client = nil

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :faraday
  c.filter_sensitive_data('{ZUORA_USERNAME}') { ENV['ZUORA_REST_CLIENT_RSPEC_USERNAME'] } if !ENV['ZUORA_REST_CLIENT_RSPEC_USERNAME'].nil?
  c.filter_sensitive_data('{ZUORA_PASSWORD}') { ENV['ZUORA_REST_CLIENT_RSPEC_PASSWORD'] } if !ENV['ZUORA_REST_CLIENT_RSPEC_PASSWORD'].nil?
  c.filter_sensitive_data('{ZUORA_SESSION_ID}') do |interaction|
    interaction.response.headers['Set-Cookie']&.map { |set_cookie_header| HTTP::Cookie.parse(set_cookie_header,interaction.request.uri) } \
        &.flatten&.select { |cookie| cookie.name == 'ZSession' }&.first&.value
  end
  c.filter_sensitive_data('{PROTECTED}') do |interaction|
    interaction.response.headers['Set-Cookie']&.map { |set_cookie_header| HTTP::Cookie.parse(set_cookie_header,interaction.request.uri) } \
        &.flatten&.select { |cookie| cookie.name == 'JSESSIONID' }&.first&.value
  end
end

def verify_env_is_set
  %w( ZUORA_REST_CLIENT_RSPEC_USERNAME
      ZUORA_REST_CLIENT_RSPEC_PASSWORD
      ZUORA_REST_CLIENT_RSPEC_AQUA_PARTNER ).each do |env|
    raise "ENV['#{env}'] is unknown" if ENV[env].nil?
  end
end