require 'test_helper'
require 'em-synchrony/dataone-vin'

module EventMachine
  module Synchrony
    describe DataoneVin do
      include TestHelpers

      before do
        DataoneVin.configure(*DATAONE_CONFIG)
      end

      it 'should work' do
        EM.synchrony do
          result = EM::Synchrony::DataoneVin.get('5TBRT3418YS094830')
          result['query_responses']['Request-Sample'].delete('transaction_id')
          result.must_equal expected_result
          EM.stop
        end
      end
    end
  end
end
