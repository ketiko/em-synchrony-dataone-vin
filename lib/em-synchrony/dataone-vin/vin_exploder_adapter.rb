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
          'B' => 'DIESEL',
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
          'year'                  => ['styles', 0, 'basic_data', 'year'],
          'make'                  => ['styles', 0, 'basic_data', 'make'],
          'model'                 => ['styles', 0, 'basic_data', 'model'],
          'trim_level'            => ['styles', 0, 'basic_data', 'trim'],
          'engine_type'           => ['styles', 0, 'engines', 0, 'name'],
          'engine_displacement'   => ['styles', 0, 'engines', 0, 'displacement'],
          'engine_shape'          => ['styles', 0, 'engines', 0, 'block_type'],
          'body_style'            => ['styles', 0, 'basic_data', 'body_type'],
          'manufactured_in'       => ['styles', 0, 'basic_data', 'country_of_manufacture'],
          'driveline'             => ['styles', 0, 'basic_data', 'drive_type'],
          'fuel_type'             => ['styles', 0, 'engines', 0, 'fuel_type'],
          'transmission-long'     => ['styles', 0,'transmissions', 0, 'name'],
          'gears'                 => ['styles', 0,'transmissions', 0, 'gears'],
          'transmission-type'     => ['styles', 0,'transmissions', 0, 'type'],
          'tank'                  => ['styles', 0, 'specifications', ['category', 'Fuel Tanks'], 'specifications', ['name', 'Fuel Tank 1 Capacity (Gallons)'], 'value'],
          'abs_two_wheel'         => ['styles', 0, 'safety_equipment', 'abs_two_wheel'],
          'abs_four_wheel'        => ['styles', 0, 'safety_equipment', 'abs_four_wheel'],
          'gvwr_class'            => ['styles', 0, 'specifications', ['category', 'Measurements of Weight'], 'specifications', ['name', 'Gross Vehicle Weight Rating'], 'value'],
          'tonnage'               => ['styles', 0, 'specifications', ['category', 'Measurements of Weight'], 'specifications', ['name', 'Tonnage'], 'value'],
          'vehicle_type'          => ['styles', 0, 'basic_data', 'vehicle_type'],
          'number_of_cylinders'   => ['styles', 0, 'engines', 0, 'cylinders'],
          'number_of_doors'       => ['styles', 0, 'basic_data', 'doors'],
          'standard_seating'      => ['styles', 0, 'specifications', ['category', 'Seating'], 'specifications', ['name', 'Standard Seating'], 'value'],
          'optional_seating'      => ['styles', 0, 'specifications', ['category', 'Seating'], 'specifications', ['name', 'Max Seating'], 'value'],
          'length'                => ['styles', 0, 'specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Length'], 'value'],
          'width'                 => ['styles', 0, 'specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Width'], 'value'],
          'height'                => ['styles', 0, 'specifications', ['category', 'Measurements of Size and Shape'], 'specifications', ['name', 'Height'], 'value'],
          'production_seq_number' => ['styles', 0, 'This will always be nil'],
          'warranties'            => ['styles', 0, 'warranties']
        }

        PASS_ERROR_CODES = [
          "CH",# chassis vehicles
          "OM" # out-of-market vehicles
        ]

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
          passes = detect_passes(response)
          return {:pass => passes} unless passes.empty?

          errors = detect_errors(response)
          return {:errors => errors} unless errors.empty?

          data = response['query_responses']['Request-Sample']
          exploded = explosion(data).merge \
            :errors        => [],
            :vin           => vin,
            :vin_key       => vin_key(vin),
            :vendor_result => data,
            :adapter       => 'dataone'
          exploded["vehicle_type"] = 'COMMERCIAL' if data["common_data"].nil?
          exploded
        end

        def detect_passes(response)
          error_code    = response['query_responses']['Request-Sample']['query_error']['error_code']
          error_message = response['query_responses']['Request-Sample']['query_error']['error_message']

          PASS_ERROR_CODES.include?(error_code) ? [error_message] : []
        end

        def detect_errors(response)
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
          data['has_turbo'] = [/turbo/i, / TC /, /supercharge/i].any? {|regex| !!(data['engine_type'] =~ regex)}
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
