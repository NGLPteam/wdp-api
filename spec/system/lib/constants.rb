# frozen_string_literal: true

module Testing
  module Constants
    MERCHANT_ID = "6SSW7HV8K2ST5"

    LOCATION_ID = "S8GWD5DBJ3HF3"

    FAKE_SQUARE_LOCATIONS = {
      "locations" => [
        {
          "id" => LOCATION_ID,
          "name" => "Default Test Account",
          "address" => {
            "address_line_1" => "1600 Pennsylvania Ave NW",
            "locality" => "Washington",
            "administrative_district_level_1" => "DC",
            "postal_code" => "20500",
            "country" => "US"
          },
          "timezone" => "UTC",
          "capabilities" => ["CREDIT_CARD_PROCESSING", "AUTOMATIC_TRANSFERS"],
          "status" => "ACTIVE",
          "created_at" => "2022-12-22T20:08:11.032Z",
          "merchant_id" => MERCHANT_ID,
          "country" => "US",
          "language_code" => "en-US",
          "currency" => "USD",
          "business_name" => "Default Test Account",
          "type" => "PHYSICAL",
          "business_hours" => {},
          "mcc" => "7299",
        }
      ]
    }.freeze

    FAKE_SQUARE_MERCHANTS = {
      "merchant" => [
        {
          "id" => MERCHANT_ID,
          "business_name" => "Default Test Account",
          "country" => "US",
          "language_code" => "en-US",
          "currency" => "USD",
          "status" => "ACTIVE",
          "main_location_id" => LOCATION_ID,
          "created_at" => "2022-12-22T20:08:11.031Z",
        }
      ]
    }.freeze
  end
end
