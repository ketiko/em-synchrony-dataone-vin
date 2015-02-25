require 'minitest/autorun'
require 'minitest/spec'

begin
  load 'dataone-config.rb'
rescue LoadError
  STDERR.puts <<-MSG
  In order to run the tests you must configure access to the dataone vin decoder api in a file called dataone-config.rb
  The file should define the following array:

  DATAONE_CONFIG = ["<your_client_id>", "<your_authorization_code>"]

  MSG
  exit 1
end

module TestHelpers
  def expected_result
    {"decoder_messages"=>
      {"service_provider"=>"DataOne Software, Inc.",
       "decoder_version"=>"7.0.0",
       "decoder_errors"=>[]},
     "query_responses"=>
      {"Request-Sample"=>
        {"query_error"=>{"error_code"=>"", "error_message"=>""},
         "common_data"=>
          {"basic_data"=>
            {"market"=>"US Light-Duty",
             "year"=>"2000",
             "make"=>"Toyota",
             "model"=>"Tundra",
             "trim"=>"SR5",
             "vehicle_type"=>"Truck",
             "body_type"=>"Pickup",
             "body_subtype"=>"Extended Cab",
             "doors"=>"4",
             "model_number"=>"7728",
             "package_code"=>"",
             "drive_type"=>"RWD",
             "brake_system"=>"",
             "restraint_type"=>"DRIVER AND PASSENGER FRONT AIRBAGS, ACTIVE BELTS",
             "country_of_manufacture"=>"",
             "plant"=>"Princeton, Indiana"},
           "pricing"=>
            {"msrp"=>"23080",
             "invoice_price"=>"0",
             "destination_charge"=>"0",
             "gas_guzzler_tax"=>"0"},
           "engines"=>
            [{"name"=>"ED 4L NA V 8 double overhead cam (DOHC) 32V",
              "brand"=>"",
              "engine_id"=>"232031",
              "availability"=>"Installed",
              "aspiration"=>"N/A",
              "block_type"=>"V",
              "bore"=>"0",
              "cam_type"=>"DOHC",
              "compression"=>"0",
              "cylinders"=>"8",
              "displacement"=>"4.7",
              "fuel_induction"=>"FI",
              "fuel_quality"=>"",
              "fuel_type"=>"G",
              "msrp"=>"0",
              "invoice_price"=>"0",
              "marketing_name"=>"",
              "max_hp"=>"245",
              "max_hp_at"=>"4800",
              "max_payload"=>"",
              "max_torque"=>"315",
              "max_torque_at"=>"3400",
              "oil_capacity"=>"0",
              "order_code"=>"",
              "redline"=>"",
              "stroke"=>"0",
              "valve_timing"=>"",
              "valves"=>"32"}],
           "transmissions"=>
            [{"name"=>"4-Speed Automatic",
              "brand"=>"",
              "transmission_id"=>"223307",
              "availability"=>"Installed",
              "type"=>"A",
              "detail_type"=>"",
              "gears"=>"4",
              "msrp"=>"0",
              "invoice_price"=>"0",
              "order_code"=>""}],
           "specifications"=>
            [{"category"=>"Drive Type",
              "specifications"=>[{"name"=>"Drive Type", "value"=>"RWD"}]},
             {"category"=>"Fuel Tanks",
              "specifications"=>
               [{"name"=>"Fuel Tank 1 Capacity (Gallons)", "value"=>"26"}]},
             {"category"=>"Measurements of Size and Shape",
              "specifications"=>
               [{"name"=>"Ground Clearance", "value"=>"10.4"},
                {"name"=>"Height", "value"=>"70.5"},
                {"name"=>"Length", "value"=>"217.5"},
                {"name"=>"Wheelbase", "value"=>"128.3"},
                {"name"=>"Width", "value"=>"75.2"}]},
             {"category"=>"Measurements of Weight",
              "specifications"=>
               [{"name"=>"Base Towing Capacity", "value"=>"7200"},
                {"name"=>"Curb Weight", "value"=>"4276"},
                {"name"=>"Gross Vehicle Weight Range", "value"=>"6001-7000"},
                {"name"=>"Gross Vehicle Weight Rating", "value"=>"6200"},
                {"name"=>"Tonnage", "value"=>"1/2"}]},
             {"category"=>"Performance Specifications",
              "specifications"=>[{"name"=>"Turning Circle", "value"=>"44.9"}]},
             {"category"=>"Seating",
              "specifications"=>
               [{"name"=>"Head Room 1st Row", "value"=>"40.3"},
                {"name"=>"Head Room 2nd Row/Rear", "value"=>"37"},
                {"name"=>"Hip Room 1st Row", "value"=>"59.3"},
                {"name"=>"Hip Room 2nd Row/Rear", "value"=>"59.3"},
                {"name"=>"Leg Room 1st Row", "value"=>"41.5"},
                {"name"=>"Leg Room 2nd Row/Rear", "value"=>"29.6"},
                {"name"=>"Max Seating", "value"=>"6"},
                {"name"=>"Shoulder Room 1st Row", "value"=>"62.4"},
                {"name"=>"Shoulder Room 2nd Row/Rear", "value"=>"63.2"},
                {"name"=>"Standard Seating", "value"=>"6"}]},
             {"category"=>"Truck Specifications",
              "specifications"=>
               [{"name"=>"Bed Code", "value"=>"SHORT"},
                {"name"=>"Max Payload", "value"=>"1924"}]},
             {"category"=>"Wheels and Tires",
              "specifications"=>
               [{"name"=>"Front Wheel Diameter", "value"=>"16 in."},
                {"name"=>"Rear Wheel Diameter", "value"=>"16 in."}]}],
           "colors"=>
            {"exterior_colors"=>
              [{"mfr_code"=>"3K4",
                "two_tone"=>"N",
                "generic_color_name"=>"Red",
                "mfr_color_name"=>"Sunfire Red Pearl",
                "primary_rgb_code"=>
                 {"r"=>"114", "g"=>"44", "b"=>"27", "hex"=>"722C1B"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"1AO",
                "two_tone"=>"N",
                "generic_color_name"=>"Silver",
                "mfr_color_name"=>"Platinum Metallic",
                "primary_rgb_code"=>
                 {"r"=>"150", "g"=>"150", "b"=>"157", "hex"=>"96969D"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"6Q7",
                "two_tone"=>"N",
                "generic_color_name"=>"Green",
                "mfr_color_name"=>"Imperial Jade Mica",
                "primary_rgb_code"=>
                 {"r"=>"40", "g"=>"110", "b"=>"90", "hex"=>"286E5A"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"578",
                "two_tone"=>"N",
                "generic_color_name"=>"Gold",
                "mfr_color_name"=>"Golden Sand Metallic",
                "primary_rgb_code"=>
                 {"r"=>"151", "g"=>"129", "b"=>"100", "hex"=>"978164"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"202",
                "two_tone"=>"N",
                "generic_color_name"=>"Black",
                "mfr_color_name"=>"Black",
                "primary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"1C7",
                "two_tone"=>"N",
                "generic_color_name"=>"Gray",
                "mfr_color_name"=>"Thunder Gray Metallic",
                "primary_rgb_code"=>
                 {"r"=>"111", "g"=>"109", "b"=>"110", "hex"=>"6F6D6E"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"056",
                "two_tone"=>"N",
                "generic_color_name"=>"White",
                "mfr_color_name"=>"Natural White",
                "primary_rgb_code"=>
                 {"r"=>"255", "g"=>"255", "b"=>"255", "hex"=>"FFFFFF"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"8L7",
                "two_tone"=>"N",
                "generic_color_name"=>"Blue",
                "mfr_color_name"=>"Stellar Blue Pearl",
                "primary_rgb_code"=>
                 {"r"=>"70", "g"=>"85", "b"=>"126", "hex"=>"46557E"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}}],
             "interior_colors"=>
              [{"mfr_code"=>"10",
                "two_tone"=>"N",
                "generic_color_name"=>"Gray",
                "mfr_color_name"=>"Gray",
                "primary_rgb_code"=>
                 {"r"=>"134", "g"=>"143", "b"=>"142", "hex"=>"868F8E"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"11",
                "two_tone"=>"N",
                "generic_color_name"=>"Dk. Gray",
                "mfr_color_name"=>"Light Charcoal",
                "primary_rgb_code"=>
                 {"r"=>"103", "g"=>"110", "b"=>"114", "hex"=>"676E72"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
               {"mfr_code"=>"40",
                "two_tone"=>"N",
                "generic_color_name"=>"Lt. Brown",
                "mfr_color_name"=>"Oak",
                "primary_rgb_code"=>
                 {"r"=>"158", "g"=>"140", "b"=>"123", "hex"=>"9E8C7B"},
                "secondary_rgb_code"=>
                 {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}}],
             "roof_colors"=>[]},
           "safety_equipment"=>
            {"abs_two_wheel"=>"",
             "abs_four_wheel"=>"",
             "airbags_front_driver"=>"",
             "airbags_front_passenger"=>"",
             "airbags_side_impact"=>"",
             "airbags_side_curtain"=>"",
             "brake_assist"=>"",
             "daytime_running_lights"=>"",
             "electronic_stability_control"=>"",
             "electronic_traction_control"=>"",
             "tire_pressure_monitoring_system"=>"",
             "rollover_stability_control"=>""},
           "warranties"=>
            [{"name"=>"Corrosion",
              "type"=>"Rust",
              "months"=>"60",
              "miles"=>"0"},
             {"name"=>"Roadside Assistance",
              "type"=>"Roadside Assistance",
              "months"=>"0",
              "miles"=>"0"},
             {"name"=>"Powertrain",
              "type"=>"Drivetrain/Powertrain",
              "months"=>"60",
              "miles"=>"60000"},
             {"name"=>"New Car Basic Warranty",
              "type"=>"Basic",
              "months"=>"36",
              "miles"=>"36000"}]},
         "styles"=>
          [{"name"=>"4 Dr SR5 V8 Extended Cab SB",
            "vehicle_id"=>"8304",
            "complete"=>"Y",
            "basic_data"=>
             {"market"=>"US Light-Duty",
              "year"=>"2000",
              "make"=>"Toyota",
              "model"=>"Tundra",
              "trim"=>"SR5",
              "vehicle_type"=>"Truck",
              "body_type"=>"Pickup",
              "body_subtype"=>"Extended Cab",
              "doors"=>"4",
              "model_number"=>"7728",
              "package_code"=>"",
              "drive_type"=>"RWD",
              "brake_system"=>"",
              "restraint_type"=>"DRIVER AND PASSENGER FRONT AIRBAGS, ACTIVE BELTS",
              "country_of_manufacture"=>"",
              "plant"=>"Princeton, Indiana"},
            "pricing"=>
             {"msrp"=>"23080",
              "invoice_price"=>"0",
              "destination_charge"=>"0",
              "gas_guzzler_tax"=>"0"},
            "engines"=>
             [{"name"=>"ED 4L NA V 8 double overhead cam (DOHC) 32V",
               "brand"=>"",
               "engine_id"=>"232031",
               "availability"=>"Installed",
               "aspiration"=>"N/A",
               "block_type"=>"V",
               "bore"=>"0",
               "cam_type"=>"DOHC",
               "compression"=>"0",
               "cylinders"=>"8",
               "displacement"=>"4.7",
               "fuel_induction"=>"FI",
               "fuel_quality"=>"",
               "fuel_type"=>"G",
               "msrp"=>"0",
               "invoice_price"=>"0",
               "marketing_name"=>"",
               "max_hp"=>"245",
               "max_hp_at"=>"4800",
               "max_payload"=>"",
               "max_torque"=>"315",
               "max_torque_at"=>"3400",
               "oil_capacity"=>"0",
               "order_code"=>"",
               "redline"=>"",
               "stroke"=>"0",
               "valve_timing"=>"",
               "valves"=>"32"}],
            "transmissions"=>
             [{"name"=>"4-Speed Automatic",
               "brand"=>"",
               "transmission_id"=>"223307",
               "availability"=>"Installed",
               "type"=>"A",
               "detail_type"=>"",
               "gears"=>"4",
               "msrp"=>"0",
               "invoice_price"=>"0",
               "order_code"=>""}],
            "specifications"=>
             [{"category"=>"Drive Type",
               "specifications"=>[{"name"=>"Drive Type", "value"=>"RWD"}]},
              {"category"=>"Fuel Tanks",
               "specifications"=>
                [{"name"=>"Fuel Tank 1 Capacity (Gallons)", "value"=>"26"}]},
              {"category"=>"Measurements of Size and Shape",
               "specifications"=>
                [{"name"=>"Ground Clearance", "value"=>"10.4"},
                 {"name"=>"Height", "value"=>"70.5"},
                 {"name"=>"Length", "value"=>"217.5"},
                 {"name"=>"Wheelbase", "value"=>"128.3"},
                 {"name"=>"Width", "value"=>"75.2"}]},
              {"category"=>"Measurements of Weight",
               "specifications"=>
                [{"name"=>"Base Towing Capacity", "value"=>"7200"},
                 {"name"=>"Curb Weight", "value"=>"4276"},
                 {"name"=>"Gross Vehicle Weight Range", "value"=>"6001-7000"},
                 {"name"=>"Gross Vehicle Weight Rating", "value"=>"6200"},
                 {"name"=>"Tonnage", "value"=>"1/2"}]},
              {"category"=>"Performance Specifications",
               "specifications"=>[{"name"=>"Turning Circle", "value"=>"44.9"}]},
              {"category"=>"Seating",
               "specifications"=>
                [{"name"=>"Head Room 1st Row", "value"=>"40.3"},
                 {"name"=>"Head Room 2nd Row/Rear", "value"=>"37"},
                 {"name"=>"Hip Room 1st Row", "value"=>"59.3"},
                 {"name"=>"Hip Room 2nd Row/Rear", "value"=>"59.3"},
                 {"name"=>"Leg Room 1st Row", "value"=>"41.5"},
                 {"name"=>"Leg Room 2nd Row/Rear", "value"=>"29.6"},
                 {"name"=>"Max Seating", "value"=>"6"},
                 {"name"=>"Shoulder Room 1st Row", "value"=>"62.4"},
                 {"name"=>"Shoulder Room 2nd Row/Rear", "value"=>"63.2"},
                 {"name"=>"Standard Seating", "value"=>"6"}]},
              {"category"=>"Truck Specifications",
               "specifications"=>
                [{"name"=>"Bed Code", "value"=>"SHORT"},
                 {"name"=>"Max Payload", "value"=>"1924"}]},
              {"category"=>"Wheels and Tires",
               "specifications"=>
                [{"name"=>"Front Wheel Diameter", "value"=>"16 in."},
                 {"name"=>"Rear Wheel Diameter", "value"=>"16 in."}]}],
            "optional_equipment"=>
             [{"category"=>"Seats",
               "options"=>
                [{"name"=>"Captain Chairs (2)",
                  "option_id"=>"14375",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Safety",
               "options"=>
                [{"name"=>"Fog Lights",
                  "option_id"=>"26001",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""},
                 {"name"=>"4-Wheel ABS",
                  "option_id"=>"130328",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Convenience Features",
               "options"=>
                [{"name"=>"Lighted Entry System",
                  "option_id"=>"40446",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Exterior Features",
               "options"=>
                [{"name"=>"Tonneau Cover",
                  "option_id"=>"71917",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""},
                 {"name"=>"Running Boards",
                  "option_id"=>"160374",
                  "order_code"=>"R94",
                  "installed"=>"UK",
                  "install_type"=>"Port Installed Option",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Tires and Rims",
               "options"=>
                [{"name"=>"Alloy Wheels",
                  "option_id"=>"120775",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Towing and Hauling",
               "options"=>
                [{"name"=>"Trailer Hitch",
                  "option_id"=>"176848",
                  "order_code"=>"TH",
                  "installed"=>"UK",
                  "install_type"=>"Port Installed Option",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Security",
               "options"=>
                [{"name"=>"Anti-Theft Alarm System",
                  "option_id"=>"300002476",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Locks",
               "options"=>
                [{"name"=>"Power Door Locks",
                  "option_id"=>"300002484",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Windows",
               "options"=>
                [{"name"=>"Power Windows",
                  "option_id"=>"300002485",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""},
                 {"name"=>"Manual Horizontal Sliding Rear Window",
                  "option_id"=>"300002519",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Truck Features",
               "options"=>
                [{"name"=>"Bed Liner",
                  "option_id"=>"300002518",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Audio System",
               "options"=>
                [{"name"=>"Cassette",
                  "option_id"=>"300005546",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""},
                 {"name"=>"In-Dash CD - single disc",
                  "option_id"=>"300005559",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""},
                 {"name"=>"Radio - AM/FM",
                  "option_id"=>"300005583",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]},
              {"category"=>"Mirrors",
               "options"=>
                [{"name"=>"Exterior mirrors - power",
                  "option_id"=>"300005660",
                  "order_code"=>"",
                  "installed"=>"UK",
                  "install_type"=>"",
                  "invoice_price"=>"0",
                  "msrp"=>"0",
                  "description"=>""}]}],
            "colors"=>
             {"exterior_colors"=>
               [{"mfr_code"=>"3K4",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Red",
                 "mfr_color_name"=>"Sunfire Red Pearl",
                 "primary_rgb_code"=>
                  {"r"=>"114", "g"=>"44", "b"=>"27", "hex"=>"722C1B"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"1AO",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Silver",
                 "mfr_color_name"=>"Platinum Metallic",
                 "primary_rgb_code"=>
                  {"r"=>"150", "g"=>"150", "b"=>"157", "hex"=>"96969D"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"6Q7",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Green",
                 "mfr_color_name"=>"Imperial Jade Mica",
                 "primary_rgb_code"=>
                  {"r"=>"40", "g"=>"110", "b"=>"90", "hex"=>"286E5A"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"578",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Gold",
                 "mfr_color_name"=>"Golden Sand Metallic",
                 "primary_rgb_code"=>
                  {"r"=>"151", "g"=>"129", "b"=>"100", "hex"=>"978164"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"202",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Black",
                 "mfr_color_name"=>"Black",
                 "primary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"1C7",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Gray",
                 "mfr_color_name"=>"Thunder Gray Metallic",
                 "primary_rgb_code"=>
                  {"r"=>"111", "g"=>"109", "b"=>"110", "hex"=>"6F6D6E"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"056",
                 "two_tone"=>"N",
                 "generic_color_name"=>"White",
                 "mfr_color_name"=>"Natural White",
                 "primary_rgb_code"=>
                  {"r"=>"255", "g"=>"255", "b"=>"255", "hex"=>"FFFFFF"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"8L7",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Blue",
                 "mfr_color_name"=>"Stellar Blue Pearl",
                 "primary_rgb_code"=>
                  {"r"=>"70", "g"=>"85", "b"=>"126", "hex"=>"46557E"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}}],
              "interior_colors"=>
               [{"mfr_code"=>"10",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Gray",
                 "mfr_color_name"=>"Gray",
                 "primary_rgb_code"=>
                  {"r"=>"134", "g"=>"143", "b"=>"142", "hex"=>"868F8E"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"11",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Dk. Gray",
                 "mfr_color_name"=>"Light Charcoal",
                 "primary_rgb_code"=>
                  {"r"=>"103", "g"=>"110", "b"=>"114", "hex"=>"676E72"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}},
                {"mfr_code"=>"40",
                 "two_tone"=>"N",
                 "generic_color_name"=>"Lt. Brown",
                 "mfr_color_name"=>"Oak",
                 "primary_rgb_code"=>
                  {"r"=>"158", "g"=>"140", "b"=>"123", "hex"=>"9E8C7B"},
                 "secondary_rgb_code"=>
                  {"r"=>"0", "g"=>"0", "b"=>"0", "hex"=>"000000"}}],
              "roof_colors"=>[]},
            "safety_equipment"=>
             {"abs_two_wheel"=>"",
              "abs_four_wheel"=>"",
              "airbags_front_driver"=>"",
              "airbags_front_passenger"=>"",
              "airbags_side_impact"=>"",
              "airbags_side_curtain"=>"",
              "brake_assist"=>"",
              "daytime_running_lights"=>"",
              "electronic_stability_control"=>"",
              "electronic_traction_control"=>"",
              "tire_pressure_monitoring_system"=>"",
              "rollover_stability_control"=>""},
            "warranties"=>
             [{"name"=>"Corrosion",
               "type"=>"Rust",
               "months"=>"60",
               "miles"=>"0"},
              {"name"=>"Roadside Assistance",
               "type"=>"Roadside Assistance",
               "months"=>"0",
               "miles"=>"0"},
              {"name"=>"Powertrain",
               "type"=>"Drivetrain/Powertrain",
               "months"=>"60",
               "miles"=>"60000"},
              {"name"=>"New Car Basic Warranty",
               "type"=>"Basic",
               "months"=>"36",
               "miles"=>"36000"}]}]}}}
  end

  def out_of_market_result
    {
      "decoder_messages"=> {
        "service_provider"=> "DataOne Software, Inc.",
        "decoder_version"=> "7.0.0",
        "decoder_errors"=> []
      },
      "query_responses"=> {
        "Request-Sample"=> {
          "query_error"=> {
            "error_code"=> "OM",
            "error_message"=> "This VIN is for an out of market vehicle. Please contact 1-877-GET-VINS for more information on how to activate out of market decoding."
          }
        }
      }
    }
  end

  def bad_vin_result
    {
      "decoder_messages"=> {
        "service_provider"=> "DataOne Software, Inc.",
        "decoder_version"=> "7.0.0",
        "decoder_errors"=>[]
      },
      "query_responses"=> {
        "Request-Sample"=> {
          "query_error"=> {
            "error_code"=> "IV",
            "error_message"=> "Invalid VIN: Not 17 characters"
          }
        }
      }
    }
  end

  def expected_heavy_duty_result
    {
      "decoder_messages"=>
      {
        "service_provider"=>"DataOne Software, Inc.",
        "decoder_version"=>"7.0.0",
        "decoder_errors"=>[]
      },
      "query_responses"=>
      {
        "Request-Sample"=>
        {
          "transaction_id"=>"5B8F9446C4398BD527992B8C718637EAF80A05E4",
          "query_error"=>
          {
            "error_code"=>"",
            "error_message"=>""
          },
          "styles"=>[
            {
              "name"=>"4X4 2dr Regular Cab 140.8-200.8 in. WB",
              "vehicle_id"=>"670000130",
              "complete"=>"Y",
              "basic_data"=>
              {
                "market"=>"Medium Duty",
                "year"=>"2007",
                "make"=>"Ford",
                "model"=>"F-550 Super Duty",
                "trim"=>"",
                "vehicle_type"=>"Truck",
                "body_type"=>"Chassis",
                "body_subtype"=>"Regular Cab",
                "doors"=>"2",
                "model_number"=>"",
                "package_code"=>"",
                "drive_type"=>"4X4",
                "brake_system"=>"Hydraulic",
                "restraint_type"=>"Driver and passenger front airbags",
                "country_of_manufacture"=>"United States",
                "plant"=>"Jefferson County, Kentucky"
              },
              "pricing"=>
              {
                "msrp"=>"",
                "invoice_price"=>"",
                "destination_charge"=>"",
                "gas_guzzler_tax"=>""
              },
              "engines"=>[
                {
                  "name"=>"Power Stroke 6.0L V8 325hp 560ft. lbs.",
                  "brand"=>"Power Stroke",
                  "engine_id"=>"0",
                  "availability"=>"Installed",
                  "aspiration"=>"T",
                  "block_type"=>"V",
                  "bore"=>"",
                  "cam_type"=>"OHV",
                  "compression"=>"",
                  "cylinders"=>"8",
                  "displacement"=>"6.0",
                  "fuel_induction"=>"CRDI",
                  "fuel_quality"=>"",
                  "fuel_type"=>"D",
                  "msrp"=>"",
                  "invoice_price"=>"",
                  "marketing_name"=>"",
                  "max_hp"=>"325-325",
                  "max_hp_at"=>"",
                  "max_payload"=>"",
                  "max_torque"=>"560-560",
                  "max_torque_at"=>"",
                  "oil_capacity"=>"",
                  "order_code"=>"",
                  "redline"=>"",
                  "stroke"=>"",
                  "valve_timing"=>"",
                  "valves"=>""
                }],
                "transmissions"=>[],
                "specifications"=>[
                  {
                    "category"=>"Measurements of Weight",
                    "specifications"=>[
                      {
                        "name"=>"Gross Vehicle Weight Range",
                        "value"=>"16001-19500"
                      },
                      {
                        "name"=>"Class",
                        "value"=>"5"
                      }]
                  },
                  {
                    "category"=>"Measurements of Size and Shape",
                    "specifications"=>[
                      {
                        "name"=>"Wheelbase",
                        "value"=>"140.8-200.8"
                      }]
                  },
                  {
                    "category"=>"Truck Specifications",
                    "specifications"=>[
                      {
                        "name"=>"Rear axle",
                        "value"=>"DRW"
                      }]
                  }],
                  "optional_equipment"=>[],
                  "colors"=>{
                    "exterior_colors"=>[],
                    "interior_colors"=>[],
                    "roof_colors"=>[]},
                  "safety_equipment"=>
                  {
                    "abs_two_wheel"=>"",
                    "abs_four_wheel"=>"",
                    "airbags_front_driver"=>"",
                    "airbags_front_passenger"=>"",
                    "airbags_side_impact"=>"",
                    "airbags_side_curtain"=>"",
                    "brake_assist"=>"",
                    "daytime_running_lights"=>"",
                    "electronic_stability_control"=>"",
                    "electronic_traction_control"=>"",
                    "tire_pressure_monitoring_system"=>"",
                    "rollover_stability_control"=>""
                  },
                  "warranties"=>[]
            }]
        }
      }
    }
  end
end
