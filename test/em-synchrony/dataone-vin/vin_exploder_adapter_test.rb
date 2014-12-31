require 'test_helper'
require 'em-synchrony/dataone-vin/vin_exploder_adapter.rb'

module EventMachine
  module Synchrony
    module DataoneVin
      describe VinExploderAdapter do
        include TestHelpers

        describe "#format_response" do
          let(:adapter) {
            VinExploderAdapter.new \
              :client_id => DATAONE_CONFIG[0],
              :authorization_code => DATAONE_CONFIG[1]
          }

          it 'should format the raw dataone json to the desired result' do
            formatted_result = adapter.format_response(expected_result, '1FT7W2BT6BEC91853')

            formatted_result['year'].must_equal '2000'
            formatted_result['make'].must_equal 'Toyota'
            formatted_result['model'].must_equal 'Tundra'
            formatted_result['trim_level'].must_equal 'SR5'
            formatted_result['engine_type'].must_equal 'ED 4L NA V 8 double overhead cam (DOHC) 32V'
            formatted_result['engine_displacement'].must_equal '4.7'
            formatted_result['engine_shape'].must_equal 'V'
            formatted_result['body_style'].must_equal 'Pickup'
            formatted_result['manufactured_in'].must_equal ''
            formatted_result['driveline'].must_equal 'RWD'
            formatted_result['fuel_type'].must_equal 'GAS'
            formatted_result['anti-brake_system'].must_equal 'No Data'
            formatted_result['gvwr_class'].must_equal '2'
            formatted_result['tonnage'].must_equal '1/2'
            formatted_result['transmission-long'].must_equal '4-Speed Automatic'
            formatted_result['transmission-short'].must_equal '4A'
            formatted_result['tank'].must_equal '26'
            formatted_result['vehicle_type'].must_equal 'TRUCK'
            formatted_result['has_turbo'].must_equal false
            formatted_result['number_of_cylinders'].must_equal '8'
            formatted_result['number_of_doors'].must_equal '4'
            formatted_result['standard_seating'].must_equal '6'
            formatted_result['optional_seating'].must_equal '6'
            formatted_result['length'].must_equal '217.5'
            formatted_result['width'].must_equal '75.2'
            formatted_result['height'].must_equal '70.5'
            formatted_result['production_seq_number'].must_be_nil
            formatted_result['warranties'].detect { |w| w['type'] == 'Basic' }.wont_be_nil
            formatted_result[:errors].must_be_empty
            formatted_result[:vin].must_equal '1FT7W2BT6BEC91853'
            formatted_result[:vin_key].must_equal '1FT7W2BTBE'
            formatted_result[:vendor_result].must_equal expected_result['query_responses']['Request-Sample']
            formatted_result[:adapter].must_equal 'dataone'
          end

          it "should detect turbo correctly" do
            defaults    = {'driveline' => '2WD', 'fuel_type' => 'gas', 'vehicle_type' => 'car'}
            turbo       = adapter.normalize({'engine_type' => '5.9L Turbocharged Diesel I6 OHV 24V FI HO Engine'}.merge(defaults))
            tc          = adapter.normalize({'engine_type' => '1L TC I 4 double overhead cam (DOHC) 20V'}.merge(defaults))
            supercharge = adapter.normalize({'engine_type' => 'a supercharged engine'}.merge(defaults))

            turbo['has_turbo'].must_equal true
            tc['has_turbo'].must_equal true
            supercharge['has_turbo'].must_equal true
          end

          it "should format a bad VIN to an error hash" do
            adapter.format_response(bad_vin_result, '1234567890ABCD').must_equal \
              :errors=>["Invalid VIN: Not 17 characters"]
          end

          it "should format a 'pass' for VINs it doesn't want to handle" do
            adapter.format_response(out_of_market_result, '2G4WJ582061169230').must_equal \
              :pass=>["This VIN is for an out of market vehicle. Please contact 1-877-GET-VINS for more information on how to activate out of market decoding."]
          end
        end
      end
    end
  end
end
