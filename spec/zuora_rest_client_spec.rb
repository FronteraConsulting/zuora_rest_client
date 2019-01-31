require 'spec_helper'

describe ZuoraRestClient do

  it 'has a version number' do
    expect(ZuoraRestClient::VERSION).not_to be nil
  end

  it 'constructs a Zuora client' do
    VCR.use_cassette('zuora/initialize_client') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      expect { $client = ZuoraRestClient::Client.new(ENV['ZUORA_REST_CLIENT_RSPEC_USERNAME'],
          ENV['ZUORA_REST_CLIENT_RSPEC_PASSWORD'], :production,
          log: true, log_level: :debug) }.to_not raise_error
    end
  end

  it 'describes the Account ZObject' do
    VCR.use_cassette('zuora/describe_account') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_result = $client.describe_object('Account')
      expect(describe_result.name).to eq('Account')
      expect(describe_result.label).to eq('Account')
    end
  end

  it 'describes all fields of the Account ZObject' do
    VCR.use_cassette('zuora/describe_all_account_fields') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_field_results = $client.describe_fields('Account')
      expect(describe_field_results.find { |item| item.name == 'Id'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'CrmId'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'Balance'}).not_to be_nil
    end
  end

  it 'describes updateable fields of the Account ZObject' do
    VCR.use_cassette('zuora/describe_updateable_account_fields') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_field_results = $client.describe_fields('Account', { updateable: true })
      expect(describe_field_results.find { |item| item.name == 'Id'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'CrmId'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'Balance'}).to be_nil
    end
  end

  it 'describes non-updateable fields of the Account ZObject' do
    VCR.use_cassette('zuora/describe_non_updateable_account_fields') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_field_results = $client.describe_fields('Account', { updateable: false })
      expect(describe_field_results.find { |item| item.name == 'Id'}).to be_nil
      expect(describe_field_results.find { |item| item.name == 'CrmId'}).to be_nil
      expect(describe_field_results.find { |item| item.name == 'Balance'}).not_to be_nil
    end
  end

  it 'describes exportable fields of the Account ZObject' do
    VCR.use_cassette('zuora/describe_exportable_account_fields') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_field_results = $client.describe_fields('Account', { exportable: true })
      expect(describe_field_results.find { |item| item.name == 'Id'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'CrmId'}).not_to be_nil
      expect(describe_field_results.find { |item| item.name == 'DefaultPaymentMethodId'}).to be_nil
    end
  end

  it 'describes non-exportable fields of the Account ZObject' do
    VCR.use_cassette('zuora/describe_non_exportable_account_fields') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_field_results = $client.describe_fields('Account', { exportable: false })
      expect(describe_field_results.find { |item| item.name == 'Id'}).to be_nil
      expect(describe_field_results.find { |item| item.name == 'CrmId'}).to be_nil
      expect(describe_field_results.find { |item| item.name == 'DefaultPaymentMethodId'}).not_to be_nil
    end
  end

  it 'describes the objects related to the Account ZObject' do
    VCR.use_cassette('zuora/describe_account_related_objects') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_related_objects_results = $client.describe_related_objects('Account')
      expect(describe_related_objects_results.find { |item| item.name == 'BillToContact'}.label).to eq('Bill To')
      expect(describe_related_objects_results.find { |item| item.name == 'SoldToContact'}.label).to eq('Sold To')
    end
  end

  it 'describes all ZObjects' do
    VCR.use_cassette('zuora/describe_all_zobjects', match_requests_on: [ :host, :path ]) do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      describe_result = $client.describe_object
      expect(describe_result.find { |item| item['name'] == 'Account' }.label).to eq('Account')
      expect(describe_result.find { |item| item['name'] == 'InvoiceItem' }.label).to eq('Invoice Item')
    end
  end

  it 'successfully creates an account with a credit card' do
    VCR.use_cassette('zuora/create_account_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      account_to_create = {
          batch: 'Batch1',
          billCycleDay: 15,
          billToContact: {
              country: 'US',
              firstName: 'Test',
              lastName: 'User',
              state: 'TX' },
          creditCard: {
              cardHolderInfo: {
                  addressLine1: '123 Anystreet Lane',
                  cardHolderName: 'Test User',
                  city: 'Anytown',
                  country: 'US',
                  state: 'TX',
                  zipCode: '00000' },
              cardNumber: '4111111111111111',
              cardType: 'Visa',
              expirationMonth: '12',
              expirationYear: '2099',
              securityCode: '123' },
          currency: 'USD',
          name: 'Test Account',
          paymentTerm: 'Due Upon Receipt' }
      result = $client.create_account(account_to_create)
      expect(result.success).to be_truthy
      expect(result.accountId).not_to be_nil
      $test_account_id_1 = result.accountId
    end
  end

  it 'successfully retrieves an account' do
    VCR.use_cassette('zuora/get_account_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      result = $client.get_account($test_account_id_1)
      expect(result.basicInfo.id).to eq($test_account_id_1)
      expect(result.basicInfo.name).to eq('Test Account')
    end
  end

  it 'successfully retrieves an account summary' do
    VCR.use_cassette('zuora/get_account_summary_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      result = $client.get_account_summary($test_account_id_1)
      expect(result.basicInfo.id).to eq($test_account_id_1)
      expect(result.basicInfo.name).to eq('Test Account')
    end
  end

  it 'successfully updates an account' do
    VCR.use_cassette('zuora/update_account_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      account_to_update = { batch: 'Batch2' }
      result = $client.update_account($test_account_id_1, account_to_update)
      expect(result.success).to be_truthy
      updated_account = $client.get_account($test_account_id_1)
      expect(updated_account.basicInfo.batch).to eq('Batch2')
    end
  end

  it 'successfully creates an account object' do
    VCR.use_cassette('zuora/create_account_object_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      account_to_create = {
          Batch: 'Batch1',
          BillCycleDay: 15,
          Currency: 'USD',
          Name: 'Test Account',
          PaymentTerm: 'Due Upon Receipt',
          Status: 'Draft' }
      result = $client.create_account_object(account_to_create)
      expect(result.Success).to be_truthy
      expect(result.Id).not_to be_nil
      $test_account_id_2 = result.Id
    end
  end

  it 'successfully retrieves an account object' do
    VCR.use_cassette('zuora/get_account_object_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      result = $client.retrieve_account_object($test_account_id_2)
      expect(result.Id).to eq($test_account_id_2)
      expect(result.Name).to eq('Test Account')
    end
  end

  it 'successfully updates an account object' do
    VCR.use_cassette('zuora/update_account_object_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      account_to_update = { Batch: 'Batch2' }
      result = $client.update_account_object($test_account_id_2, account_to_update)
      expect(result.Success).to be_truthy
      updated_account = $client.retrieve_account_object($test_account_id_2)
      expect(updated_account.Id).to eq($test_account_id_2)
      expect(updated_account.Batch).to eq('Batch2')
    end
  end

  it 'successfully deletes account objects' do
    VCR.use_cassette('zuora/delete_account_object_success') do |cassette|
      verify_env_is_set if cassette.originally_recorded_at.nil?
      [$test_account_id_1, $test_account_id_2].each do |account_id|
        result = $client.delete_account_object(account_id)
        expect(result.success).to be_truthy
        sleep 5
        deleted_account = $client.retrieve_account_object(account_id)
        expect(deleted_account.size).to eq(0)
      end
    end
  end

end
