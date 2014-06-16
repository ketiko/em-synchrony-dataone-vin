require 'test_helper'
require 'em-synchrony/dataone-vin'

module EventMachine
  module Synchrony
    describe DataoneVin do
      before do
        DataoneVin.configure(*DATAONE_CONFIG)
      end

      it 'should work' do
        EM.synchrony do
          result = EM::Synchrony::DataoneVin.get('5TBRT3418YS094830')

          result['decoder_messages']['service_provider'].must_equal "DataOne Software, Inc."
          result['decoder_messages']['decoder_version'].must_equal "7.0.0"
          result['decoder_messages']['decoder_errors'].must_be_empty

          result['query_responses']['Request-Sample']['query_error']['error_code'].must_be_empty
          result['query_responses']['Request-Sample']['query_error']['error_message'].must_be_empty

          result['query_responses']['Request-Sample']['common_data']['basic_data']['year'].must_equal "2000"
          result['query_responses']['Request-Sample']['common_data']['basic_data']['make'].must_equal "Toyota"
          result['query_responses']['Request-Sample']['common_data']['basic_data']['model'].must_equal "Tundra"

          EM.stop
        end
      end
    end
  end
end
