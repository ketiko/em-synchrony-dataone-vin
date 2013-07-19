require 'minitest/autorun'
require 'minitest/spec'

require 'em-synchrony/dataone-vin'

module EventMachine
  module Synchrony
    describe DataoneVin do
      it 'should work' do
        EM.synchrony do
          require 'pp'
          pp JSON::load EM::Synchrony::DataoneVin.get('5TBRT3418YS094830').response

          EM.stop
        end
      end
    end
  end
end
