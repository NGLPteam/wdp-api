# frozen_string_literal: true

module Schemas
  module Properties
    # A concern that requires any class implementing it to have a `#properties` method
    #
    # @see Schemas::Properties::CompileSchema
    module CompilesToSchema
      extend ActiveSupport::Concern

      # @return [Schemas::BaseContract]
      def to_dry_validation
        WDPAPI::Container["schemas.properties.compile_contract"].call(self).value!
      end

      # @see Schemas::Properties::CompileSchema
      # @return [Dry::Schema::Params]
      def to_dry_schema
        WDPAPI::Container["schemas.properties.compile_schema"].call(properties)
      end
    end
  end
end
