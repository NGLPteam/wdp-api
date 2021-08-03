# frozen_string_literal: true

module Schemas
  module Properties
    # A concern that requires any class implementing it to have a `#properties` method
    #
    # @see Schemas::Properties::CompileSchema
    module CompilesToSchema
      extend ActiveSupport::Concern

      # @return [Dry::Schema]
      def to_dry_schema
        result = WDPAPI::Container["schemas.properties.compile_schema"].call(properties)

        result.value!
      end
    end
  end
end
