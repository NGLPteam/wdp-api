# frozen_string_literal: true

module TestHelpers
  module VariableDates
    module ExampleHelpers
      # @see VariablePrecision::ParseDate#call
      # @param [String, Date, Integer, nil] value
      # @return [VariablePrecisionDate]
      def variable_date(value)
        WDPAPI::Container["variable_precision.parse_date"].call(value).value!
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::VariableDates::ExampleHelpers
end
