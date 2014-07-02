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
            adapter.format_response(expected_result, '1FT7W2BT6BEC91853').must_equal \
              'year'                  => '2000',
              'make'                  => 'Toyota',
              'model'                 => 'Tundra',
              'trim_level'            => 'SR5',
              'engine_type'           => 'ED 4L NA V 8 double overhead cam (DOHC) 32V',
              'engine_displacement'   => '4.7',
              'engine_shape'          => 'V',
              'body_style'            => 'Pickup',
              'manufactured_in'       => '',
              'driveline'             => 'RWD',
              'fuel_type'             => 'GAS',
              'anti-brake_system'     => 'No Data',
              'gvwr_class'            => '2',
              'tonnage'               => '1/2',
              'transmission-long'     => '4-Speed Automatic',
              'transmission-short'    => '4A',
              'tank'                  => '26',
              'vehicle_type'          => 'TRUCK',
              'has_turbo'             => false,
              'number_of_cylinders'   => '8',
              'number_of_doors'       => '4',
              'standard_seating'      => '6',
              'optional_seating'      => '6',
              'length'                => '217.5',
              'width'                 => '75.2',
              'height'                => '70.5',
              'production_seq_number' => nil,
              :errors                 => [],
              :vin                    => '1FT7W2BT6BEC91853',
              :vin_key                => '1FT7W2BTBE',
              :vendor_result          => expected_result['query_responses']['Request-Sample']
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
