require 'zuora_rest_client/connection'
require 'addressable/uri'
require 'fire_poll'
require 'base64'
require 'date'

require 'active_support'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

module ZuoraRestClient

  class Client

    DEFAULT_CLIENT_OPTIONS = {
        logger: Logger.new($stdout),
        log_level: :error,
        log: true }

    DEFAULT_AQUA_QUERY_OPTIONS = {
        wait_for_completed_result: true,
        max_wait: 3600,
        poll_delay: 2 }

    DEFAULT_EXPORT_OPTIONS = {
        format: :csv,
        zip: false,
        name: nil,
        encrypted: false,
        max_wait: 3600,
        poll_delay: 2 }

    def initialize(username, password, environment = :production, options = {})
      @client_options = {}.merge(DEFAULT_CLIENT_OPTIONS).merge(options)
      @connection = ZuoraRestClient::Connection.new(username, password, environment, options)
    end

    ##############################################################################
    #                                                                            #
    #  Actions                                                                   #
    #                                                                            #
    ##############################################################################

    def amend(request, zuora_version = nil)
      @connection.rest_post('/action/amend', request, zuora_version)
    end

    def create(request, zuora_version = nil)
      @connection.rest_post('/action/create', request, zuora_version)
    end

    def delete(request, zuora_version = nil)
      @connection.rest_post('/action/delete', request, zuora_version)
    end

    def execute(request, zuora_version = nil)
      @connection.rest_post('/action/execute', request, zuora_version)
    end

    def generate(request, zuora_version = nil)
      @connection.rest_post('/action/generate', request, zuora_version)
    end

    def query(request, zuora_version = nil)
      @connection.rest_post('/action/query', request, zuora_version)
    end

    def query_more(request, zuora_version = nil)
      @connection.rest_post('/action/queryMore', request, zuora_version)
    end

    def subscribe(request, zuora_version = nil)
      @connection.rest_post('/action/subscribe', request, zuora_version)
    end

    def update(request, zuora_version = nil)
      @connection.rest_post('/action/update', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Accounting Codes                                                          #
    #                                                                            #
    ##############################################################################

    def create_accounting_code(request, zuora_version = nil)
      @connection.rest_post('/accounting-codes', request, zuora_version)
    end

    def get_all_accounting_codes(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/accounting-codes')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def activate_accounting_code(accounting_code_id, zuora_version = nil)
      @connection.rest_put("/accounting-codes/#{accounting_code_id}/activate", nil, zuora_version)
    end

    def deactivate_accounting_code(accounting_code_id, zuora_version = nil)
      @connection.rest_put("/accounting-codes/#{accounting_code_id}/deactivate", nil, zuora_version)
    end

    def delete_accounting_code(accounting_code_id, zuora_version = nil)
      @connection.rest_delete("/accounting-codes/#{accounting_code_id}", zuora_version)
    end

    def query_accounting_code(accounting_code_id, zuora_version = nil)
      @connection.rest_get("/accounting-codes/#{accounting_code_id}", zuora_version)
    end

    def update_accounting_code(accounting_code_id, request, zuora_version = nil)
      @connection.rest_put("/accounting-codes/#{accounting_code_id}", request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Accounting Periods                                                        #
    #                                                                            #
    ##############################################################################

    def close_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_put("/accounting-periods/#{accounting_period_id}/close", nil, zuora_version)
    end

    def pending_close_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_put("/accounting-periods/#{accounting_period_id}/pending-close", nil, zuora_version)
    end

    def create_accounting_period(request, zuora_version = nil)
      @connection.rest_post('/accounting-periods', request, zuora_version)
    end

    def get_all_accounting_periods(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/accounting-periods')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_get("/accounting-periods/#{accounting_period_id}", zuora_version)
    end

    def update_accounting_period(accounting_period_id, request, zuora_version = nil)
      @connection.rest_put("/accounting-periods/#{accounting_period_id}", request, zuora_version)
    end

    def delete_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_delete("/accounting-periods/#{accounting_period_id}", zuora_version)
    end

    def reopen_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_put("/accounting-periods/#{accounting_period_id}/reopen", nil, zuora_version)
    end

    def run_trial_balance_on_accounting_period(accounting_period_id, zuora_version = nil)
      @connection.rest_put("/accounting-periods/#{accounting_period_id}/run-trial_balance", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Accounts                                                                  #
    #                                                                            #
    ##############################################################################

    def create_account(request, zuora_version = nil)
      @connection.rest_post('/accounts', request, zuora_version)
    end

    def get_account(account_key, zuora_version = nil)
      @connection.rest_get("/accounts/#{account_key}", zuora_version)
    end

    def update_account(account_key, request, zuora_version = nil)
      @connection.rest_put("/accounts/#{account_key}", request, zuora_version)
    end

    def get_account_summary(account_key, zuora_version = nil)
      @connection.rest_get("/accounts/#{account_key}/summary", zuora_version)
    end

    def create_account_object(request, zuora_version = nil)
      @connection.rest_post('/object/account', request, zuora_version)
    end

    def retrieve_account_object(account_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/account/#{account_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_account_object(account_id, request, zuora_version = nil)
      @connection.rest_put("/object/account/#{account_id}", request, zuora_version)
    end

    def delete_account_object(account_id, zuora_version = nil)
      @connection.rest_delete("/object/account/#{account_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Amendments                                                                #
    #                                                                            #
    ##############################################################################

    def get_amendment(amendment_key, zuora_version = nil)
      @connection.rest_get("/amendments/#{amendment_key}", zuora_version)
    end

    def get_amendment_by_subscription_id(subscription_id, zuora_version = nil)
      @connection.rest_get("/amendments/subscriptions/#{subscription_id}", zuora_version)
    end

    def create_amendment_object(request, zuora_version = nil)
      @connection.rest_post('/object/amendment', request, zuora_version)
    end

    def retrieve_amendment_object(amendment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/amendment/#{amendment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_amendment_object(amendment_id, request, zuora_version = nil)
      @connection.rest_put("/object/amendment/#{amendment_id}", request, zuora_version)
    end

    def delete_amendment_object(amendment_id, zuora_version = nil)
      @connection.rest_delete("/object/amendment/#{amendment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  AQuA                                                                      #
    #                                                                            #
    ##############################################################################

    def aqua_query(request, options = {})
      aqua_query_options = {}.merge(DEFAULT_AQUA_QUERY_OPTIONS).merge(options)
      result = @connection.app_post('/apps/api/batch-query/', request)
      logger.debug "********* AQUA POST QUERY RESULT: #{result.inspect}"

      raise "Error: #{result.message}" if result.status.downcase == 'error'

      if aqua_query_options[:wait_for_completed_result]
        poll_started = false
        FirePoll.poll(nil, aqua_query_options[:max_wait]) do
          sleep aqua_query_options[:poll_delay] if poll_started
          poll_started = true
          result = get_aqua_job_result(result.id)
          logger.debug "********* CURRENT AQUA JOB STATUS: #{result.inspect}"
          raise "Error: #{result.message}" if result.status.downcase == 'error'
          result.status.downcase != 'submitted' && result.status.downcase.end_with?('ed')
        end

        logger.debug "********* FINAL AQUA JOB STATUS: #{result.inspect}"
      end

      result
    end

    def get_aqua_job_result(job_id)
      @connection.app_get("/apps/api/batch-query/jobs/#{job_id}")
    end

    def get_last_aqua_job_result(partner, project)
      @connection.app_get("/apps/api/batch-query/jobs/partner/#{partner}/project/#{project}")
    end

    ##############################################################################
    #                                                                            #
    #  Attachments                                                               #
    #                                                                            #
    ##############################################################################

    def add_attachment(source_filename_or_io, source_content_type, associated_object_type, associated_object_key, description = nil, zuora_version = nil)
      payload = { file: Faraday::UploadIO(source_filename_or_io, source_content_type) }
      uri = Addressable::URI.parse('/attachments')
      query_values = { associatedObjectType: associated_object_type.to_s, associatedObjectKey: associated_object_key.to_s }
      query_values[:description] = description if !description.nil?
      uri.query_values = query_values
      @connection.rest_post(uri.to_s, payload, zuora_version, false)
    end

    def view_attachment_list(associated_object_type, associated_object_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/attachments/#{associated_object_type}/#{associated_object_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def view_attachment(attachment_id, zuora_version = nil)
      @connection.rest_get("/attachments/#{attachment_id}", zuora_version)
    end

    def edit_attachment(attachment_id, request, zuora_version = nil)
      @connection.rest_put("/attachments/#{attachment_id}", request, zuora_version)
    end

    def delete_attachment(attachment_id, zuora_version = nil)
      @connection.rest_delete("/attachments/#{attachment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Bill Run                                                                  #
    #                                                                            #
    ##############################################################################

    def create_bill_run_object(request, zuora_version = nil)
      @connection.rest_post('/object/bill-run', request, zuora_version)
    end

    def retrieve_bill_run_object(bill_run_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/bill-run/#{bill_run_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_bill_run_object(bill_run_id, request, zuora_version = nil)
      @connection.rest_put("/object/bill-run/#{bill_run_id}", request, zuora_version)
    end

    def delete_bill_run_object(bill_run_id, zuora_version = nil)
      @connection.rest_delete("/object/bill-run/#{bill_run_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Billing Preview Run                                                       #
    #                                                                            #
    ##############################################################################

    def create_billing_preview_run(request, zuora_version = nil)
      @connection.rest_post('/billing-preview-runs', request, zuora_version)
    end

    def get_billing_preview_run(billing_preview_run_id, zuora_version = nil)
      @connection.rest_get("/billing-preview-runs/#{billing_preview_run_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Catalog                                                                   #
    #                                                                            #
    ##############################################################################

    def get_product_catalog(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/catalog/products')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def share_product_with_entities(product_id, request, zuora_version = nil)
      @connection.rest_put("/catalog/products/#{product_id}/share", request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Charge Revenue Summaries                                                  #
    #                                                                            #
    ##############################################################################

    def get_charge_summary_details_by_crs_number(crs_number, zuora_version = nil)
      @connection.rest_get("/charge-revenue-summaries/#{crs_number}", zuora_version)
    end

    def get_charge_summary_details_by_charge_id(charge_id, zuora_version = nil)
      @connection.rest_get("/charge-revenue-summaries/subscription-charges/#{charge_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Communication Profiles                                                    #
    #                                                                            #
    ##############################################################################

    def retrieve_communication_profile_object(communication_profile_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/communication-profile/#{communication_profile_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_communication_profile_object(communication_profile_id, zuora_version = nil)
      @connection.rest_delete("/object/communication-profile/#{communication_profile_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Contacts                                                                  #
    #                                                                            #
    ##############################################################################

    def create_contact_object(request, zuora_version = nil)
      @connection.rest_post('/object/contact', request, zuora_version)
    end

    def retrieve_contact_object(contact_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/contact/#{contact_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get("/object/contact/#{contact_id}", zuora_version)
    end

    def update_contact_object(contact_id, request, zuora_version = nil)
      @connection.rest_put("/object/contact/#{contact_id}", request, zuora_version)
    end

    def delete_contact_object(contact_id, zuora_version = nil)
      @connection.rest_delete("/object/contact/#{contact_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Credit Balance Adjustments                                                #
    #                                                                            #
    ##############################################################################

    def retrieve_credit_balance_adjustment_object(credit_balance_adjustment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/credit-balance-adjustment/#{credit_balance_adjustment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_credit_balance_adjustment_object(credit_balance_adjustment_id, zuora_version = nil)
      @connection.rest_delete("/object/credit-balance-adjustment/#{credit_balance_adjustment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Credit Memos                                                              #
    #                                                                            #
    ##############################################################################

    def get_credit_memo(credit_memo_id, zuora_version = nil)
      @connection.rest_get("/creditmemos/#{credit_memo_id}", zuora_version)
    end

    def delete_credit_memo(credit_memo_id, zuora_version = nil)
      @connection.rest_delete("/creditmemos/#{credit_memo_id}", zuora_version)
    end

    def update_credit_memo(credit_memo_id, request, zuora_version = nil)
      @connection.rest_put("/creditmemos/#{credit_memo_id}", request, zuora_version)
    end

    def post_credit_memo(credit_memo_id, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/post", nil, zuora_version)
    end

    def get_credit_memo_item(credit_memo_id, credit_memo_item_id, zuora_version = nil)
      @connection.rest_get("/creditmemos/#{credit_memo_id}/items/#{credit_memo_item_id}", zuora_version)
    end

    def refund_credit_memo(credit_memo_id, request, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/refund", request, zuora_version)
    end

    def query_credit_memos_by_account(request, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/creditmemos/query')
      uri.query_values = query_params
      @connection.rest_post(uri.to_s, request, zuora_version)
    end

    def get_credit_memo_parts(credit_memo_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/creditmemos/#{credit_memo_id}/parts")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def apply_credit_memo(credit_memo_id, request, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/apply", request, zuora_version)
    end

    def get_credit_memo_items(credit_memo_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/creditmemos/#{credit_memo_id}/items")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_credit_memo_part_items(credit_memo_id, part_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/creditmemos/#{credit_memo_id}/parts/#{part_id}/itemparts")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def unapply_credit_memo(credit_memo_id, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/unapply", request, zuora_version)
    end

    def create_credit_memo_from_invoice(invoice_id, request, zuora_version = nil)
      @connection.rest_post("/creditmemos/invoice/#{invoice_id}", request, zuora_version)
    end

    def get_credit_memo_part_item(credit_memo_id, part_id, item_part_id, zuora_version = nil)
      @connection.rest_get("/creditmemos/#{credit_memo_id}/parts/#{part_id}/itemparts/#{item_part_id}", zuora_version)
    end

    def create_credit_memo_from_charge(request, zuora_version = nil)
      @connection.rest_post('/creditmemos', request, zuora_version)
    end

    def get_credit_memos(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/creditmemos')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_credit_memo_part(credit_memo_id, part_id, zuora_version = nil)
      @connection.rest_get("/creditmemos/#{credit_memo_id}/parts/#{part_id}", zuora_version)
    end

    def cancel_credit_memo(credit_memo_id, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/cancel", nil, zuora_version)
    end

    def create_credit_memo_pdf(credit_memo_id, zuora_version = nil)
      @connection.rest_post("/creditmemos/#{credit_memo_id}/pdfs", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Custom Exchange Rates                                                     #
    #                                                                            #
    ##############################################################################

    def get_custom_exchange_rates(currency, start_date, end_date, zuora_version = nil)
      if start_date.is_a? Date
        start_date = start_date.iso8601
      elsif start_date.is_a? DateTime
        start_date = start_date.to_date.iso8601
      end
      if end_date.is_a? Date
        end_date = end_date.iso8601
      elsif end_date.is_a? DateTime
        end_date = end_date.to_date.iso8601
      end
      uri = Addressable::URI.parse("/custom-exchange-rates/#{currency}")
      uri.query_values = { startDate: start_date, endDate: end_date }
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Debit Memos                                                               #
    #                                                                            #
    ##############################################################################

    def get_debit_memo_item(debit_memo_id, debit_memo_item_id, zuora_version = nil)
      @connection.rest_get("/debitmemos/#{debit_memo_id}/items/#{debit_memo_item_id}", zuora_version)
    end

    def create_debit_memo_from_invoice(invoice_id, request, zuora_version = nil)
      @connection.rest_post("/debitmemos/invoice/#{invoice_id}", request, zuora_version)
    end

    def create_debit_memo_from_charge(request, zuora_version = nil)
      @connection.rest_post("/debitmemos", request, zuora_version)
    end

    def get_debit_memos(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/debitmemos')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def create_debit_memo_pdf(debit_memo_id, zuora_version = nil)
      @connection.rest_post("/debitmemos/#{debit_memo_id}/pdfs", nil, zuora_version)
    end

    def get_debit_memo_items(debit_memo_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/debitmemos/#{debit_memo_id}/items")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def cancel_debit_memo(debit_memo_id, zuora_version = nil)
      @connection.rest_post("/debitmemos/#{debit_memo_id}/cancel", nil, zuora_version)
    end

    def get_debit_memo(debit_memo_id, zuora_version = nil)
      @connection.rest_get("/debitmemos/#{debit_memo_id}", zuora_version)
    end

    def delete_debit_memo(debit_memo_id, zuora_version = nil)
      @connection.rest_delete("/debitmemos/#{debit_memo_id}", zuora_version)
    end

    def update_debit_memo(debit_memo_id, request, zuora_version = nil)
      @connection.rest_put("/debitmemos/#{debit_memo_id}", request, zuora_version)
    end

    def post_debit_memo(debit_memo_id, zuora_version = nil)
      @connection.rest_post("/debitmemos/#{debit_memo_id}/post", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Describe                                                                  #
    #                                                                            #
    ##############################################################################

    def describe_object(object = '', zuora_version = nil)
      path = "/describe/#{object}"
      path = "/#{zuora_version.to_s}#{path}" if !zuora_version.nil?
      result = @connection.rest_get(path)
      if result.respond_to?(:objects)

        # Listing all objects
        result = result.objects.object

      elsif result.respond_to?(:object)

        # Returning single object
        result = result.object
        result.fields = result.fields.field if result.fields
        result.related_objects = result.related_objects.object if result.related_objects
        result.fields.map! do |field|
          field.contexts = field.contexts.context if field.contexts
          field.options = field.options.option if field.options
          field
        end

      end

      result
    end

    def describe_fields(object, field_filter_options = {}, zuora_version = nil)

      return [] if object.nil? || object == ''

      # Invoke Zuora describe
      results = describe_object(object, zuora_version)
      results = results.fields

      # Filter results
      results.select! do |field|

        match = true

        # Process field filters
        %w(selectable createable updateable filterable custom).each do |option|
          if field_filter_options[option.to_sym] == true
            match &&= field[option.to_sym]
          elsif field_filter_options[option.to_sym] == false
            match &&= !field[option.to_sym]
          end
        end

        # Process nested field filters
        %w(soap export).each do |context|
          if field_filter_options["#{context}able".to_sym] == true
            match &&= field.contexts.include?(context)
          elsif field_filter_options["#{context}able".to_sym] == false
            match &&= !field.contexts.include?(context)
          end
        end

        match
      end

      # Sort results by field name
      results.sort! { |a, b| a.name <=> b.name }

      results
    end

    def describe_related_objects(object, zuora_version = nil)

      return [] if object.nil? || object == ''

      # Invoke Zuora describe
      results = describe_object(object, zuora_version)
      results = results.related_objects

      results
    end

    ##############################################################################
    #                                                                            #
    #  Entities                                                                  #
    #                                                                            #
    ##############################################################################

    def create_entity(request, zuora_version = nil)
      @connection.rest_post('/entities', request, zuora_version)
    end

    def get_entities(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/entities')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_entity(entity_id, request, zuora_version = nil)
      @connection.rest_put("/entities/#{entity_id}", request, zuora_version)
    end

    def get_entity(entity_id, zuora_version = nil)
      @connection.rest_get("/entities/#{entity_id}", zuora_version)
    end

    def delete_entity(entity_id, zuora_version = nil)
      @connection.rest_delete("/entities/#{entity_id}", zuora_version)
    end

    def provision_entity(entity_id, zuora_version = nil)
      @connection.rest_put("/entities/#{entity_id}/provision", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Entity Connections                                                        #
    #                                                                            #
    ##############################################################################

    def get_entity_connections(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/entity-connections')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def initiate_entity_connection(request, zuora_version = nil)
      @connection.rest_post('/entity-connections', request, zuora_version)
    end

    def accept_entity_connection(entity_connection_id, zuora_version = nil)
      @connection.rest_put("/entity-connections/#{entity_connection_id}/accept", nil, zuora_version)
    end

    def deny_entity_connection(entity_connection_id, zuora_version = nil)
      @connection.rest_put("/entity-connections/#{entity_connection_id}/deny", nil, zuora_version)
    end

    def disconnect_entity_connection(entity_connection_id, zuora_version = nil)
      @connection.rest_put("/entity-connections/#{entity_connection_id}/disconnect", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Exports                                                                   #
    #                                                                            #
    ##############################################################################

    def create_export_object(request, zuora_version = nil)
      @connection.rest_post('/object/export', request, zuora_version)
    end

    def retrieve_export_object(export_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/export/#{export_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_export_object(export_id, zuora_version = nil)
      @connection.rest_delete("/object/export/#{export_id}", zuora_version)
    end

    def export(export_zoql, destination_io, options = {}, delete_export_from_server = true)

      export_options = {}.merge(DEFAULT_EXPORT_OPTIONS).merge(options)

      # Construct export request
      export_request = {
          Format: export_options[:format].to_s,
          Query: export_zoql,
          Zip: export_options[:zip],
          Encrypted: export_options[:encrypted] }
      if !export_options[:name].nil?
        export_request[:Name] = export_options[:name]
      end

      # Submit create export request
      create_export_result = create_export_result(export_request)
      logger.debug "********* EXPORT CREATE RESULT: #{create_export_result.inspect}"
      unless create_export_result.Success
        raise "Error creating export: #{create_export_result.Errors.map { |error| error.message }.join('; ')}"
      end

      # Poll Zuora until CSV is ready for download
      poll_started = false
      export_record = nil
      FirePoll.poll(nil, export_options[:max_wait]) do
        sleep export_options[:poll_delay] if poll_started
        poll_started = true
        poll_query_request = {
            queryString: "SELECT Id, FileId, Status, StatusReason FROM Export WHERE Id = '#{create_export_result.Id}'" }
        poll_query_result = query(poll_query_request)
        export_record = poll_query_result.records.first
        logger.debug "********* CURRENT EXPORT STATUS: #{export_record.Status}"
        export_record.Status.end_with? 'ed'
      end

      # Check status and if complete, output file to destination IO
      logger.debug "********* FINAL EXPORT STATUS: #{export_record.Status}"
      case export_record.Status
        when 'Completed'
          get_file(export_zobject.FileId, destination_io)
        when 'Canceled'
          raise "Error downloading file: #{export_record.Status} - #{export_record.StatusReason}"
        when 'Failed'
          raise "Error downloading file: #{export_record.Status} - #{export_record.StatusReason}"
      end

      # If requested, delete export from server
      if delete_export_from_server
        delete_export_object(export_record.Id)
      end

      export_record
    end

    ##############################################################################
    #                                                                            #
    #  Features                                                                  #
    #                                                                            #
    ##############################################################################

    def retrieve_feature_object(feature_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/feature/#{feature_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_feature_object(feature_id, zuora_version = nil)
      @connection.rest_delete("/object/feature/#{feature_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Get Files                                                                 #
    #                                                                            #
    ##############################################################################

    def get_file(file_id, destination_io, zuora_version = nil)
      @connection.rest_streamed_get("/files/#{file_id}", destination_io, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  HMAC Signatures                                                           #
    #                                                                            #
    ##############################################################################

    def hmac_signature(request, zuora_version = nil)
      @connection.rest_post('/hmac-signatures', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Hosted Pages                                                              #
    #                                                                            #
    ##############################################################################

    def get_hosted_pages(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/hostedpages')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Imports                                                                   #
    #                                                                            #
    ##############################################################################

    def retrieve_import_object(import_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/import/#{import_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_import_object(import_id, zuora_version = nil)
      @connection.rest_delete("/object/import/#{import_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Adjustments                                                       #
    #                                                                            #
    ##############################################################################

    def create_invoice_adjustment_object(request, zuora_version = nil)
      @connection.rest_post('/object/invoice-adjustment', request, zuora_version)
    end

    def retrieve_invoice_adjustment_object(invoice_adjustment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-adjustment/#{invoice_adjustment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_invoice_adjustment_object(invoice_adjustment_id, request, zuora_version = nil)
      @connection.rest_put("/object/invoice-adjustment/#{invoice_adjustment_id}", request, zuora_version)
    end

    def delete_invoice_adjustment_object(invoice_adjustment_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-adjustment/#{invoice_adjustment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Item Adjustments                                                  #
    #                                                                            #
    ##############################################################################

    def retrieve_invoice_item_adjustment_object(invoice_item_adjustment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-item-adjustment/#{invoice_item_adjustment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_invoice_item_adjustment_object(invoice_item_adjustment_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-item-adjustment/#{invoice_item_adjustment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Items                                                             #
    #                                                                            #
    ##############################################################################

    def retrieve_invoice_item_object(invoice_item_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-item/#{invoice_item_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_invoice_item_object(invoice_item_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-item/#{invoice_item_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Payments                                                          #
    #                                                                            #
    ##############################################################################

    def create_invoice_payment_object(request, zuora_version = nil)
      @connection.rest_post('/object/invoice-payment', request, zuora_version)
    end

    def retrieve_invoice_payment_object(invoice_payment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-payment/#{invoice_payment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_invoice_payment_object(invoice_payment_id, request, zuora_version = nil)
      @connection.rest_put("/object/invoice-payment/#{invoice_payment_id}", request, zuora_version)
    end

    def delete_invoice_payment_object(invoice_payment_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-payment/#{invoice_payment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Split Items                                                       #
    #                                                                            #
    ##############################################################################

    def retrieve_invoice_split_item_object(invoice_split_item_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-split-item/#{invoice_split_item_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_invoice_split_item_object(invoice_split_item_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-split-item/#{invoice_split_item_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoice Splits                                                            #
    #                                                                            #
    ##############################################################################

    def retrieve_invoice_split_object(invoice_split_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice-split/#{invoice_split_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_invoice_split_object(invoice_split_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice-split/#{invoice_split_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Invoices                                                                  #
    #                                                                            #
    ##############################################################################

    def reverse_invoice(invoice_id, zuora_version = nil)
      @connection.rest_put("/invoices/#{invoice_id}/reverse", nil, zuora_version)
    end

    def create_invoice_object(request, zuora_version = nil)
      @connection.rest_post('/object/invoice', request, zuora_version)
    end

    def retrieve_invoice_object(invoice_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/invoice/#{invoice_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_invoice_object(invoice_id, request, zuora_version = nil)
      @connection.rest_put("/object/invoice/#{invoice_id}", request, zuora_version)
    end

    def delete_invoice_object(invoice_id, zuora_version = nil)
      @connection.rest_delete("/object/invoice/#{invoice_id}", zuora_version)
    end

    def get_invoice_pdf_by(identifying_field_sym, identifier, destination_io)
      raise "Unsupported identifying_field_sym. Expected: :id or :invoice_number, Actual: #{identifying_field_sym}" if ![:id, :invoice_number].include?(identifying_field_sym)

      # Set IO to binary mode
      destination_io.try(:binmode)

      # Query invoice Id or number
      results = query({ queryString: "select Id, Body from Invoice where #{identifying_field_sym.to_s.camelize} = '#{identifier.gsub("'", %q(\\\'))}'" })
      raise "Cannot find invoice where #{identifying_field_sym.to_s.camelize} = '#{identifier}'" if results.size == 0

      # Write body to IO
      invoice = results.records.first
      destination_io.try(:write, Base64.decode64(invoice.Body))

      # Set pointer to beginning of file
      destination_io.try(:rewind)

      # Return nothing
      nil

    end

    ##############################################################################
    #                                                                            #
    #  Journal Runs                                                              #
    #                                                                            #
    ##############################################################################

    def create_journal_run(request, zuora_version = nil)
      @connection.rest_post('/journal-runs', request, zuora_version)
    end

    def get_journal_run(journal_run_number, zuora_version = nil)
      @connection.rest_get("/journal-runs/#{journal_run_number}", zuora_version)
    end

    def delete_journal_run(journal_run_number, zuora_version = nil)
      @connection.rest_delete("/journal-runs/#{journal_run_number}", zuora_version)
    end

    def cancel_journal_run(journal_run_number, zuora_version = nil)
      @connection.rest_put("/journal-runs/#{journal_run_number}/cancel", nil, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Mass Updater                                                              #
    #                                                                            #
    ##############################################################################

    def perform_mass_action(source_filename_or_io, source_content_type, params_hash, zuora_version = nil)
      payload = { file: Faraday::UploadIO(source_filename_or_io, source_content_type), params: params_hash }
      @connection.rest_post('/bulk', payload, zuora_version, false)
    end

    def get_mass_action_result(bulk_key, zuora_version = nil)
      @connection.rest_get("/bulk/#{bulk_key}", zuora_version)
    end

    def stop_mass_action(bulk_key, zuora_version = nil)
      @connection.rest_put("/bulk/#{bulk_key}/stop", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Notification History                                                      #
    #                                                                            #
    ##############################################################################

    def get_callout_notification_history(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/notification-history/callout')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_email_notification_history(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/notification-history/email')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  OAuth                                                                     #
    #                                                                            #
    ##############################################################################

    def generate_oauth_token(request, zuora_version = nil)
      @connection.rest_post('/oauth/token', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Operations                                                                #
    #                                                                            #
    ##############################################################################

    def invoice_and_collect(request, zuora_version = nil)
      @connection.rest_post('/operations/invoice-collect', request, zuora_version)
    end

    def create_billing_preview(request, zuora_version = nil)
      @connection.rest_post('/operations/billing-preview', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payment Gateways                                                          #
    #                                                                            #
    ##############################################################################

    def get_payment_gateways(zuora_version = nil)
      @connection.rest_get('/paymentgateways', zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payment Method Snapshots                                                  #
    #                                                                            #
    ##############################################################################

    def retrieve_payment_method_snapshot_object(payment_method_snapshot_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/payment-method-snapshot/#{payment_method_snapshot_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_payment_method_snapshot_object(payment_method_snapshot_id, zuora_version = nil)
      @connection.rest_delete("/object/payment-method-snapshot/#{payment_method_snapshot_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payment Method Transaction Logs                                           #
    #                                                                            #
    ##############################################################################

    def retrieve_payment_method_transaction_log_object(payment_method_transaction_log_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/payment-method-transaction-log/#{payment_method_transaction_log_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_payment_method_transaction_log_object(payment_method_transaction_log_id, zuora_version = nil)
      @connection.rest_delete("/object/payment-method-transaction-log/#{payment_method_transaction_log_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payment Method                                                            #
    #                                                                            #
    ##############################################################################

    def create_payment_method(request, zuora_version = nil)
      @connection.rest_post('/payment-methods/credit-cards', request, zuora_version)
    end

    def get_payment_methods(account_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/payment-methods/credit-cards/accounts/#{account_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_payment_method(payment_method_id, request, zuora_version = nil)
      @connection.rest_put("/payment-methods/credit-cards/#{payment_method_id}", request, zuora_version)
    end

    def delete_payment_method(payment_method_id, zuora_version = nil)
      @connection.rest_delete("/payment-methods/credit-cards/#{payment_method_id}", zuora_version)
    end

    def create_payment_method_decryption(request, zuora_version = nil)
      @connection.rest_post('/payment-methods/decryption', request, zuora_version)
    end

    def create_payment_method_object(request, zuora_version = nil)
      @connection.rest_post('/object/payment-method', request, zuora_version)
    end

    def retrieve_payment_method_object(payment_method_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/payment-method/#{payment_method_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_payment_method_object(payment_method_id, request, zuora_version = nil)
      @connection.rest_put("/object/payment-method/#{payment_method_id}", request, zuora_version)
    end

    def delete_payment_method_object(payment_method_id, zuora_version = nil)
      @connection.rest_delete("/object/payment-method/#{payment_method_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payment Transaction Logs                                                  #
    #                                                                            #
    ##############################################################################

    def retrieve_payment_transaction_log_object(payment_transaction_log_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/payment-transaction-log/#{payment_transaction_log_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_payment_transaction_log_object(payment_transaction_log_id, zuora_version = nil)
      @connection.rest_delete("/object/payment-transaction-log/#{payment_transaction_log_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Payments                                                                  #
    #                                                                            #
    ##############################################################################

    def unapply_payment(payment_id, request, zuora_version = nil)
      @connection.rest_post("/payments/#{payment_id}/unapply", request, zuora_version)
    end

    def get_payment_parts(payment_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.new("/payments/#{payment_id}/parts")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_payment_part_items(payment_id, part_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.new("/payments/#{payment_id}/parts/#{part_id}/itemparts")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def apply_payment(payment_id, request, zuora_version = nil)
      @connection.rest_post("/payments/#{payment_id}/apply", request, zuora_version)
    end

    def refund_payment(payment_id, request, zuora_version = nil)
      @connection.rest_post("/payments/#{payment_id}/refund", request, zuora_version)
    end

    def create_payment(request, zuora_version = nil)
      @connection.rest_post('/payments', request, zuora_version)
    end

    def get_all_payments(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.new('/payments')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_payment_part(payment_id, part_id, zuora_version = nil)
      @connection.rest_get("/payments/#{payment_id}/parts/#{part_id}", zuora_version)
    end

    def get_payment_part_item(payment_id, part_id, item_part_id, zuora_version = nil)
      @connection.rest_get("/payments/#{payment_id}/parts/#{part_id}/itemparts/#{item_part_id}", zuora_version)
    end

    def transfer_payment(payment_id, request, zuora_version = nil)
      @connection.rest_post("/payments/#{payment_id}/accounts", request, zuora_version)
    end

    def cancel_payment(payment_id, zuora_version = nil)
      @connection.rest_post("/payments/#{payment_id}/cancel", nil, zuora_version)
    end

    def get_payment(payment_id, zuora_version = nil)
      @connection.rest_get("/payments/#{payment_id}", zuora_version)
    end

    def delete_payment(payment_id, zuora_version = nil)
      @connection.rest_delete("/payments/#{payment_id}", zuora_version)
    end

    def update_payment(payment_id, request, zuora_version = nil)
      @connection.rest_put("/payments/#{payment_id}", request, zuora_version)
    end

    def create_payment_object(request, zuora_version = nil)
      @connection.rest_post('/object/payment', request, zuora_version)
    end

    def retrieve_payment_object(payment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/payment/#{payment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_payment_object(payment_id, request, zuora_version = nil)
      @connection.rest_put("/object/payment/#{payment_id}", request, zuora_version)
    end

    def delete_payment_object(payment_id, zuora_version = nil)
      @connection.rest_delete("/object/payment/#{payment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Product Features                                                          #
    #                                                                            #
    ##############################################################################

    def retrieve_product_feature_object(product_feature_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/product-feature/#{product_feature_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_product_feature_object(product_feature_id, zuora_version = nil)
      @connection.rest_delete("/object/product-feature/#{product_feature_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Product Rate Plan Charge Tiers                                            #
    #                                                                            #
    ##############################################################################

    def retrieve_product_rate_plan_charge_tier_object(product_rate_plan_charge_tier_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/product-rate-plan-charge-tier/#{product_rate_plan_charge_tier_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_product_rate_plan_charge_tier_object(product_rate_plan_charge_tier_id, zuora_version = nil)
      @connection.rest_delete("/object/product-rate-plan-charge-tier/#{product_rate_plan_charge_tier_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Product Rate Plan Charges                                                 #
    #                                                                            #
    ##############################################################################

    def retrieve_product_rate_plan_charge_object(product_rate_plan_charge_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/product-rate-plan-charge/#{product_rate_plan_charge_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_product_rate_plan_charge_object(product_rate_plan_charge_id, zuora_version = nil)
      @connection.rest_delete("/object/product-rate-plan-charge/#{product_rate_plan_charge_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Product Rate Plans                                                        #
    #                                                                            #
    ##############################################################################

    def get_product_rate_plans(product_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/rateplan/#{product_id}/productRatePlan")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def create_product_rate_plan_object(request, zuora_version = nil)
      @connection.rest_post('/object/product-rate-plan', request, zuora_version)
    end

    def retrieve_product_rate_plan_object(product_rate_plan_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/product-rate-plan/#{product_rate_plan_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_product_rate_plan_object(product_rate_plan_id, request, zuora_version = nil)
      @connection.rest_put("/object/product-rate-plan/#{product_rate_plan_id}", request, zuora_version)
    end

    def delete_product_rate_plan_object(product_rate_plan_id, zuora_version = nil)
      @connection.rest_delete("/object/product-rate-plan/#{product_rate_plan_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Products                                                                  #
    #                                                                            #
    ##############################################################################

    def create_product_object(request, zuora_version = nil)
      @connection.rest_post('/object/product', request, zuora_version)
    end

    def retrieve_product_object(product_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/product/#{product_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_product_object(product_id, request, zuora_version = nil)
      @connection.rest_put("/object/product/#{product_id}", request, zuora_version)
    end

    def delete_product_object(product_id, zuora_version = nil)
      @connection.rest_delete("/object/product/#{product_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Quotes Document                                                           #
    #                                                                            #
    ##############################################################################

    def generate_quote_document(request, zuora_version = nil)
      @connection.rest_post('/quotes/document', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Rate Plan Charge Tiers                                                    #
    #                                                                            #
    ##############################################################################

    def retrieve_rate_plan_charge_tier_object(rate_plan_charge_tier_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/rate-plan-charge-tier/#{rate_plan_charge_tier_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_rate_plan_charge_tier_object(rate_plan_charge_tier_id, zuora_version = nil)
      @connection.rest_delete("/object/rate-plan-charge-tier/#{rate_plan_charge_tier_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Rate Plan Charges                                                         #
    #                                                                            #
    ##############################################################################

    def retrieve_rate_plan_charge_object(rate_plan_charge_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/rate-plan-charge/#{rate_plan_charge_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_rate_plan_charge_object(rate_plan_charge_id, zuora_version = nil)
      @connection.rest_delete("/object/rate-plan-charge/#{rate_plan_charge_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Rate Plans                                                                #
    #                                                                            #
    ##############################################################################

    def retrieve_rate_plan_object(rate_plan_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/rate-plan/#{rate_plan_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_rate_plan_object(rate_plan_id, zuora_version = nil)
      @connection.rest_delete("/object/rate-plan/#{rate_plan_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Refund Invoice Payments                                                   #
    #                                                                            #
    ##############################################################################

    def retrieve_refund_invoice_payment_object(refund_invoice_payment_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/refund-invoice-payment/#{refund_invoice_payment_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_refund_invoice_payment_object(refund_invoice_payment_id, zuora_version = nil)
      @connection.rest_delete("/object/refund-invoice-payment/#{refund_invoice_payment_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Refund Transaction Logs                                                   #
    #                                                                            #
    ##############################################################################

    def retrieve_refund_transaction_log_object(refund_transaction_log_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/refund-transaction-log/#{refund_transaction_log_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_refund_transaction_log_object(refund_transaction_log_id, zuora_version = nil)
      @connection.rest_delete("/object/refund-transaction-log/#{refund_transaction_log_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Refunds                                                                   #
    #                                                                            #
    ##############################################################################

    def get_refund(refund_id, zuora_version = nil)
      @connection.rest_get("/refunds/#{refund_id}", zuora_version)
    end

    def delete_refund(refund_id, zuora_version = nil)
      @connection.rest_delete("/refunds/#{refund_id}", zuora_version)
    end

    def update_refund(refund_id, request, zuora_version = nil)
      @connection.rest_put("/refunds/#{refund_id}", request, zuora_version)
    end

    def get_refund_part_items(refund_id, refund_part_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/refunds/#{refund_id}/parts/#{refund_part_id}/itemparts")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_all_refunds(query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse('/refunds')
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_refund_parts(refund_id, zuora_version = nil)
      @connection.rest_get("/refunds/#{refund_id}/parts", zuora_version)
    end

    def get_refund_part(refund_id, refund_part_id, zuora_version = nil)
      @connection.rest_get("/refunds/#{refund_id}/parts/#{refund_part_id}", zuora_version)
    end

    def get_refund_part_item(refund_id, refund_part_id, item_part_id, zuora_version = nil)
      @connection.rest_get("/refunds/#{refund_id}/parts/#{refund_part_id}/itemparts/#{item_part_id}", zuora_version)
    end

    def cancel_refund(refund_id, zuora_version = nil)
      @connection.rest_post("/refunds/#{refund_id}/cancel", zuora_version)
    end

    def create_refund_object(request, zuora_version = nil)
      @connection.rest_post('/object/refund', request, zuora_version)
    end

    def retrieve_refund_object(refund_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/refund/#{refund_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_refund_object(refund_id, request, zuora_version = nil)
      @connection.rest_put("/object/refund/#{refund_id}", request, zuora_version)
    end

    def delete_refund_object(refund_id, zuora_version = nil)
      @connection.rest_delete("/object/refund/#{refund_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Revenue Events                                                            #
    #                                                                            #
    ##############################################################################

    def get_revenue_event_details(event_number, zuora_version = nil)
      @connection.rest_get("/revenue-events/#{event_number}", zuora_version)
    end

    def get_revenue_event_for_revenue_schedule(revenue_schedule_number, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-events/revenue-schedules/#{revenue_schedule_number}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Revenue Items                                                             #
    #                                                                            #
    ##############################################################################

    def get_revenue_items_by_crs_number(crs_number, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-items/charge-revenue-summaries/#{crs_number}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_revenue_items_by_revenue_event_number(event_number, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-items/revenue-events/#{event_number}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_revenue_items_by_revenue_event_number(event_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-items/revenue-events/#{event_number}", request, zuora_version)
    end

    def get_revenue_items_by_revenue_schedule(revenue_schedule_number, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-items/revenue-schedules/#{revenue_schedule_number}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_revenue_items_by_revenue_schedule(revenue_schedule_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-items/revenue-schedules/#{revenue_schedule_number}", request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Revenue Rules                                                             #
    #                                                                            #
    ##############################################################################

    def get_revenue_recognition_rule_by_subscription_charge(charge_id, zuora_version = nil)
      @connection.rest_get("/revenue-recognition-rules/subscription-charges/#{charge_id}", zuora_version)
    end

    def get_revenue_recognition_rule_by_product_rate_plan_charge(charge_id, zuora_version = nil)
      @connection.rest_get("/revenue-recognition-rules/product-charges/#{charge_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Revenue Schedules                                                         #
    #                                                                            #
    ##############################################################################

    def create_revenue_schedule_for_invoice_item_distribute_by_date_range(invoice_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/invoice-items/#{invoice_item_id}/distribute-revenue-with-date-range", request, zuora_version)
    end

    def create_revenue_schedule_for_invoice_item_distribute_manually(invoice_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/invoice-items/#{invoice_item_id}", request, zuora_version)
    end

    def get_revenue_schedule_by_invoice_item(invoice_item_id, zuora_version = nil)
      @connection.rest_get("/revenue-schedules/invoice-items/#{invoice_item_id}", zuora_version)
    end

    def create_revenue_schedule_for_invoice_item_adjustment_distribute_by_date_range(invoice_item_adjustment_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/invoice-item-adjustments/#{invoice_item_adjustment_id}/distribute-revenue-with-date-range", request, zuora_version)
    end

    def create_revenue_schedule_for_invoice_item_adjustment_distribute_manually(invoice_item_adjustment_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/invoice-items/#{invoice_item_adjustment_id}", request, zuora_version)
    end

    def create_revenue_schedule_on_subscription_charge(charge_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/subscription-charges/#{charge_id}", request, zuora_version)
    end

    def get_revenue_schedule_by_subscription_charge(charge_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-schedules/subscription-charges/#{charge_id}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def distribute_revenue_across_accounting_periods(revenue_schedule_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-schedules/#{revenue_schedule_number}/distribute-revenue-across-accounting-periods", request, zuora_version)
    end

    def distribute_revenue_on_specific_date(revenue_schedule_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-schedules/#{revenue_schedule_number}/distribute-revenue-on-specific-date", request, zuora_version)
    end

    def distribute_revenue_by_date_range(revenue_schedule_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-schedules/#{revenue_schedule_number}/distribute-revenue-with-date-range", request, zuora_version)
    end

    def delete_revenue_schedule(revenue_schedule_number, zuora_version = nil)
      @connection.rest_delete("/revenue-schedules/#{revenue_schedule_number}", zuora_version)
    end

    def get_revenue_schedule_details(revenue_schedule_number, zuora_version = nil)
      @connection.rest_get("/revenue-schedules/#{revenue_schedule_number}", zuora_version)
    end

    def get_revenue_schedule_by_invoice_item_adjustment(invoice_item_adjustement_id, zuora_version = nil)
      @connection.rest_get("/revenue-schedules/invoice-item-adjustments/#{invoice_item_adjustement_id}", zuora_version)
    end

    def update_revenue_schedule_basic_information(revenue_schedule_number, request, zuora_version = nil)
      @connection.rest_put("/revenue-schedules/#{revenue_schedule_number}/basic-information", request, zuora_version)
    end

    def create_revenue_schedule_for_credit_memo_item_distribute_by_date_range(credit_memo_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/credit-memo-items/#{credit_memo_item_id}/distribute-revenue-with-date-range", request, zuora_version)
    end

    def create_revenue_schedule_for_debit_memo_item_distribute_by_date_range(debit_memo_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/debit-memo-items/#{debit_memo_item_id}/distribute-revenue-with-date-range", request, zuora_version)
    end

    def create_revenue_schedule_for_credit_memo_item_distribute_manually(credit_memo_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/credit-memo-items/#{credit_memo_item_id}", request, zuora_version)
    end

    def get_revenue_schedule_by_credit_memo_item(credit_memo_item_id, zuora_version = nil)
      @connection.rest_get("/revenue-schedules/credit-memo-items/#{credit_memo_item_id}", zuora_version)
    end

    def create_revenue_schedule_for_debit_memo_item_distribute_manually(debit_memo_item_id, request, zuora_version = nil)
      @connection.rest_post("/revenue-schedules/debit-memo-items/#{debit_memo_item_id}", request, zuora_version)
    end

    def get_revenue_schedule_by_debit_memo_item(debit_memo_item_id, zuora_version = nil)
      @connection.rest_get("/revenue-schedules/debit-memo-items/#{debit_memo_item_id}", zuora_version)
    end

    def get_all_revenue_schedules_of_product_charges(charge_id, account_id, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/revenue-schedules/product-charges/#{charge_id}/#{account_id}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  RSA Signatures                                                            #
    #                                                                            #
    ##############################################################################

    def generate_rsa_signature(request, zuora_version = nil)
      @connection.rest_post('/rsa-signatures', request, zuora_version)
    end

    def decrypt_rsa_signature(request, zuora_version = nil)
      @connection.rest_post('/rsa-signatures/decrypt', request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Settings                                                                  #
    #                                                                            #
    ##############################################################################

    def get_revenue_automation_start_date(zuora_version = nil)
      @connection.rest_get('/settings/finance/revenue-automation-start-date', zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Subscription Product Features                                             #
    #                                                                            #
    ##############################################################################

    def retrieve_subscription_product_feature_object(subscription_product_feature_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/subscription-product-feature/#{subscription_product_feature_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def delete_subscription_product_feature_object(product_feature_id, zuora_version = nil)
      @connection.rest_delete("/object/subscription-product-feature/#{subscription_product_feature_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Subscriptions                                                             #
    #                                                                            #
    ##############################################################################

    def preview_subscription(request, zuora_version = nil)
      @connection.rest_post('/subscriptions/preview', request, zuora_version)
    end

    def create_subscription(request, zuora_version = nil)
      @connection.rest_post('/subscriptions', request, zuora_version)
    end

    def get_subscriptions_by_account(account_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/subscriptions/accounts/#{account_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_subscription(subscription_key, request, zuora_version = nil)
      @connection.rest_put("/subscriptions/#{subscription_key}", request, zuora_version)
    end

    def get_subscription_by_key(subscription_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/subscriptions/#{subscription_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_subscription_by_key_and_version(subscription_key, version, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/subscriptions/#{subscription_key}/versions/#{version}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def renew_subscription(subscription_key, request, zuora_version = nil)
      @connection.rest_put("/subscriptions/#{subscription_key}/renew", request, zuora_version)
    end

    def cancel_subscription(subscription_key, request, zuora_version = nil)
      @connection.rest_put("/subscriptions/#{subscription_key}/cancel", request, zuora_version)
    end

    def resume_subscription(subscription_key, request, zuora_version = nil)
      @connection.rest_put("/subscriptions/#{subscription_key}/resume", request, zuora_version)
    end

    def suspend_subscription(subscription_key, request, zuora_version = nil)
      @connection.rest_put("/subscriptions/#{subscription_key}/suspend", request, zuora_version)
    end

    def retrieve_subscription_object(subscription_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/subscription/#{subscription_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get("/object/subscription/#{subscription_id}", zuora_version)
    end

    def update_subscription_object(subscription_id, request, zuora_version = nil)
      @connection.rest_put("/object/subscription/#{subscription_id}", request, zuora_version)
    end

    def delete_subscription_object(subscription_id, zuora_version = nil)
      @connection.rest_delete("/object/subscription/#{subscription_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Summary Journal Entries                                                   #
    #                                                                            #
    ##############################################################################

    def create_summary_journal_entry(request, zuora_version = nil)
      @connection.rest_post('/journal-entries', request, zuora_version)
    end

    def get_all_summary_journal_entries_for_journal_run(journal_run_number, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/journal-entries/journal-runs/#{journal_run_number}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_summary_journal_entry(journal_entry_number, zuora_version = nil)
      @connection.rest_get("/journal-entries/#{journal_entry_number}", zuora_version)
    end

    def delete_summary_journal_entry(journal_entry_number, zuora_version = nil)
      @connection.rest_delete("/journal-entries/#{journal_entry_number}", zuora_version)
    end

    def cancel_summary_journal_entry(journal_entry_number, zuora_version = nil)
      @connection.rest_put("/journal-entries/#{journal_entry_number}/cancel", nil, zuora_version)
    end

    def update_summary_journal_entry_basic_information(journal_entry_number, request, zuora_version = nil)
      @connection.rest_put("/journal-entries/#{journal_entry_number}/basic-information", request, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Taxation Item                                                             #
    #                                                                            #
    ##############################################################################

    def get_taxation_item(taxation_item_id, zuora_version = nil)
      @connection.rest_get("/taxationitems/#{taxation_item_id}", zuora_version)
    end

    def delete_taxation_item(taxation_item_id, zuora_version = nil)
      @connection.rest_delete("/taxationitems/#{taxation_item_id}", zuora_version)
    end

    def update_taxation_item(taxation_item_id, request, zuora_version = nil)
      @connection.rest_put("/taxationitems/#{taxation_item_id}", request, zuora_version)
    end

    def create_taxation_item_for_credit_memo(memo_id, request, zuora_version = nil)
      @connection.rest_post("/taxationitems/creditmemo/#{memo_id}", request, zuora_version)
    end

    def create_taxation_item_for_debit_memo(memo_id, request, zuora_version = nil)
      @connection.rest_post("/taxationitems/debitmemo/#{memo_id}", request, zuora_version)
    end

    def create_taxation_item_object(request, zuora_version = nil)
      @connection.rest_post('/object/taxation-item', request, zuora_version)
    end

    def retrieve_taxation_item_object(taxation_item_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/taxation-item/#{taxation_item_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_taxation_item_object(taxation_item_id, request, zuora_version = nil)
      @connection.rest_put("/object/taxation-item/#{taxation_item_id}", request, zuora_version)
    end

    def delete_taxation_item_object(taxation_item_id, zuora_version = nil)
      @connection.rest_delete("/object/taxation-item/#{taxation_item_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Transactions                                                              #
    #                                                                            #
    ##############################################################################

    def get_invoice_transactions(account_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/transactions/invoices/accounts/#{account_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def get_payment_transactions(account_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/transactions/payments/accounts/#{account_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Unit of Measure                                                           #
    #                                                                            #
    ##############################################################################

    def create_unit_of_measure_object(request, zuora_version = nil)
      @connection.rest_post('/object/unit-of-measure', request, zuora_version)
    end

    def retrieve_unit_of_measure_object(unit_of_measure_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/unit-of-measure/#{unit_of_measure_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_unit_of_measure_object(unit_of_measure_id, request, zuora_version = nil)
      @connection.rest_put("/object/unit-of-measure/#{unit_of_measure_id}", request, zuora_version)
    end

    def delete_unit_of_measure_object(unit_of_measure_id, zuora_version = nil)
      @connection.rest_delete("/object/unit-of-measure/#{unit_of_measure_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Usage                                                                     #
    #                                                                            #
    ##############################################################################

    def post_usage(source_filename_or_io, source_content_type, zuora_version = nil)
      payload = { file: Faraday::UploadIO(source_filename_or_io, source_content_type) }
      @connection.rest_post('/usage', payload, zuora_version, false)
    end

    def get_usage(account_key, query_params = {}, zuora_version = nil)
      uri = Addressable::URI.parse("/usage/accounts/#{account_key}")
      uri.query_values = query_params
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def create_usage_object(request, zuora_version = nil)
      @connection.rest_post('/object/usage', request, zuora_version)
    end

    def retrieve_usage_object(usage_id, fields = nil, zuora_version = nil)
      uri = Addressable::URI.parse("/object/usage/#{usage_id}")
      uri.query_values = { fields: fields.to_s } if !fields.nil?
      @connection.rest_get(uri.to_s, zuora_version)
    end

    def update_usage_object(usage_id, request, zuora_version = nil)
      @connection.rest_put("/object/usage/#{usage_id}", request, zuora_version)
    end

    def delete_usage_object(usage_id, zuora_version = nil)
      @connection.rest_delete("/object/usage/#{usage_id}", zuora_version)
    end

    ##############################################################################
    #                                                                            #
    #  Users                                                                     #
    #                                                                            #
    ##############################################################################

    def send_user_access_request(username, request, zuora_version = nil)
      @connection.rest_put("/users/#{username}/request-access", request, zuora_version)
    end

    def accept_user_access(username, zuora_version = nil)
      @connection.rest_put("/users/#{username}/accept-access", nil, zuora_version)
    end

    def deny_user_access(username, zuora_version = nil)
      @connection.rest_put("/users/#{username}/deny-access", nil, zuora_version)
    end

    def get_accessible_entities_for_user(username, zuora_version = nil)
      @connection.rest_get("/users/#{username}/accessible-entities", zuora_version)
    end

    private

    def logger
      result = @client_options[:logger] || Logger.new($stdout)
      log_level = (@client_options[:log_level] || :info).to_s.upcase
      result.level = Logger::INFO
      result.level = Logger.const_get(log_level) if Logger.const_defined?(log_level)
      result
    end

  end

end
