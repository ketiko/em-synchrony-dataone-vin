require 'em-synchrony/dataone-vin'

module EventMachine
  module Synchrony
    module DataoneVin
      class VinExploderAdapter
        class Error < ::StandardError; end

        DRIVELINE_TYPES = {
          '4x4' => '4WD',
          '4X4' => '4WD',
          '4x2' => 'RWD',
          '4X2' => 'RWD',
        }

        FUEL_TYPES = {
          'B' => 'BIODIESEL',
          'D' => 'DIESEL',
          'F' => 'FFV',
          'G' => 'GAS',
          'I' => 'HYBRID',
          'L' => 'ELECTRIC',
          'N' => 'NATURALGAS',
          'P' => 'PETROLEUM',
          'Y' => 'HYBRID',
        }

        BRAKE_TYPES = {
          ['Not Available', 'Not Available'] => 'Non-ABS',
          ['Not Available', 'Standard']      => '4-Wheel ABS',
          ['Not Available', 'Optional']      => 'Non-ABS | 4-Wheel ABS',
          ['Standard', 'Not Available'] => '2-Wheel ABS',
          ['Standard', 'Standard']      => '2-Wheel ABS | 4-Wheel ABS',
          ['Standard', 'Optional']      => '2-Wheel ABS | 4-Wheel ABS',
          ['Optional', 'Not Available'] => 'Non-ABS | 2-Wheel ABS',
          ['Optional', 'Standard']      => '2-Wheel ABS | 4-Wheel ABS',
          ['Optional', 'Optional']      => 'Non-ABS | 2-Wheel ABS | 4-Wheel ABS',
        }

        DATA_PATHS = {
          'year'                  => ['basic_data', 'year'],
          'make'                  => ['basic_data', 'make'],
          'model'                 => ['basic_data', 'model'],
          'trim_level'            => ['basic_data', 'trim'],
          'engine_type'           => ['engines', 0, 'name'],
          'engine_displacement'   => ['engines', 0, 'displacement'],
          'engine_shape'          => ['engines', 0, 'block_type'],
          'body_style'            => ['basic_data', 'body_type'],
          'manufactured_in'       => ['basic_data', 'country_of_manufacture'],
          'driveline'             => ['basic_data', 'drive_type'],
          'fuel_type'             => ['engines', 0, 'fuel_type'],
          'transmission-long'     => ['transmissions', 0, 'name'],
          'gears'                 => ['transmissions', 0, 'gears'],
          'transmission-type'     => ['transmissions', 0, 'type'],
          'tank'                  => ['specifications', ['category', 'Fuel Tanks'], 'specifications', ['name', 'Fuel Tank 1 Capacity (Gallons)'], 'value'],
          'abs_two_wheel'         => ['safety_equipment', 'abs_two_wheel'],
          'abs_four_wheel'        => ['safety_equipment', 'abs_four_wheel'],
          'gvwr_class'            => ['specifications', ['category', 'Measurements of Weight'], 'specifications', ['name', 'Gross Vehicle Weight Rating'], 'value'],
          'vehicle_type'          => ['basic_data', 'vehicle_type'],
          'number_of_cylinders'   => ['engines', 0, 'cylinders'],
          'number_of_doors'       => ['basic_data', 'doors'],
          'standard_seating'      => ['specifications', ['category', 'Seating'], 'specifications', ['name', 'Standard Seating'], 'value'],
          'optional_seating'      => ['specifications', ['category', 'Seating'], 'specifications', ['name', 'Max Seating'], 'value'],
          'length'                => ['specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Length'], 'value'],
          'width'                 => ['specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Width'], 'value'],
          'height'                => ['specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Height'], 'value'],
          'production_seq_number' => ['This will always be nil'],
        }

        def initialize(options)
          client_id, authorization_code = options.values_at(:client_id, :authorization_code)

          unless client_id && authorization_code
            raise Error.new "DataoneVin::VinExploderAdapter requires both a client_id and an authorization_code"
          end

          DataoneVin.configure client_id, authorization_code
        end

        def explode(vin)
          format_response DataoneVin.get(vin), vin
        end

        def format_response(response, vin)
          errors = errors(response)
          return {:errors => errors} unless errors.empty?

          data = response['query_responses']['Request-Sample']
          explosion(data['common_data']).merge \
            :errors        => [],
            :vin           => vin,
            :vin_key       => vin_key(vin),
            :vendor_result => data
        end

        def errors(response)
          query_error = response['query_responses']['Request-Sample']['query_error']['error_message']
          errors = response['decoder_messages']['decoder_errors']
          errors << query_error unless query_error.empty?
          errors
        end

        def explosion(data)
          normalize Hash[DATA_PATHS.map do |(key, path)|
            [key, lookup_data(data, path)]
          end]
        end

        def lookup_data(data, path)
          path.reduce(data) do |d, (k, v)|
            if v
              d.find{|h| h[k] == v}
            else
              d[k]
            end
          end
        rescue
          nil
        end

        def normalize(data)
          data['driveline'] = normalize_driveline data['driveline']
          data['fuel_type'] = normalize_fuel_type data['fuel_type']
          data['vehicle_type'] = data['vehicle_type'].upcase
          data['has_turbo'] = !!(data['engine_type'] =~ /turbo/i)
          data['transmission-short'] = "#{data.delete('gears')}#{data.delete('transmission-type')}"
          data['anti-brake_system'] = normalize_brakes data.delete('abs_two_wheel'), data.delete('abs_four_wheel')
          data['gvwr_class'] = normalize_gvwr_class data['gvwr_class']

          data
        end

        def normalize_driveline(driveline)
          DRIVELINE_TYPES.fetch(driveline, driveline)
        end

        def normalize_fuel_type(fuel_type)
          FUEL_TYPES.fetch(fuel_type, 'No data')
        end

        def normalize_brakes(abs_two_wheel, abs_four_wheel)
          BRAKE_TYPES.fetch([abs_two_wheel, abs_four_wheel], 'No Data')
        end

        def normalize_gvwr_class(weight_rating)
          case weight_rating.to_i
          when 0..6_000                then '1'
          when 6_001..10_000           then '2'
          when 10_001..14_000          then '3'
          when 14_001..16_000          then '4'
          when 16_001..19_500          then '5'
          when 19_501..26_000          then '6'
          when 26_001..33_000          then '7'
          when 33_001..Float::INFINITY then '8'
          else                              '1'
          end
        end

        def vin_key(vin)
          "#{vin[0,8]}#{vin[9,2]}"
        end
      end
    end
  end
end
