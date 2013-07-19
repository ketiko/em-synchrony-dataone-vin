require 'em-synchrony/dataone-vin/version'
require 'json'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

module EventMachine
  module Synchrony
    module DataoneVin
      module_function

      def configure(client_id, authorization_code)
        @dataone_config = {
          :client_id => client_id,
          :authorization_code => authorization_code
        }
      end

      def get(vin)
        EM::HttpRequest.new(request_url).post \
          :head => {:content_type => 'application/x-www-form-urlencoded'},
          :body => request_hash(vin)
      end

      def request_url
        "https://www.dataonesoftware.com/webservices/vindecoder/decode"
      end

      def request_hash(vin)
        @dataone_config.merge :decoder_query => decoder_settings(vin)
      end

      def decoder_settings(vin)
        JSON::dump \
          "decoder_settings"=>
           {"display"=>"full",
            "version"=>"7.0.0",
            "styles"=>"on",
            "style_data_packs"=>
             {"basic_data"=>"on",
              "pricing"=>"on",
              "engines"=>"on",
              "transmissions"=>"on",
              "specifications"=>"on",
              "optional_equipment"=>"on",
              "colors"=>"on",
              "safety_equipment"=>"on",
              "warranties"=>"on"},
            "common_data"=>"on",
            "common_data_packs"=>
             {"basic_data"=>"on",
              "pricing"=>"on",
              "engines"=>"on",
              "transmissions"=>"on",
              "specifications"=>"on",
              "colors"=>"on",
              "safety_equipment"=>"on",
              "warranties"=>"on"}},
          "query_requests"=>
           {"Request-Sample"=>
             {"vin"=>vin,
              "year"=>"",
              "make"=>"",
              "model"=>"",
              "trim"=>"",
              "model_number"=>"",
              "package_code"=>"",
              "drive_type"=>"",
              "vehicle_type"=>"",
              "body_type"=>"",
              "body_subtype"=>"",
              "doors"=>"",
              "bedlength"=>"",
              "wheelbase"=>"",
              "msrp"=>"",
              "invoice_price"=>"",
              "engine"=>
               {"description"=>"",
                "block_type"=>"",
                "cylinders"=>"",
                "displacement"=>"",
                "fuel_type"=>""},
              "transmission"=>{"description"=>"", "trans_type"=>"", "trans_speeds"=>""},
              "optional_equipment_codes"=>"",
              "installed_equipment_descriptions"=>"",
              "interior_color"=>{"description"=>"", "color_code"=>""},
              "exterior_color"=>{"description"=>"", "color_code"=>""}}}
      end
    end
  end
end
