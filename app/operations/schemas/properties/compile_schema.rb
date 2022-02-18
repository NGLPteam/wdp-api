# frozen_string_literal: true

module Schemas
  module Properties
    # @deprecated
    class CompileSchema
      # @param [<Schemas::Properties::BaseDefinition>] properties
      # @return [Dry::Schema::Params]
      def call(properties)
        Dry::Schema.Params do
          config.types = Schemas::Properties::Types::Registry

          properties.each do |property|
            property.add_to_schema! self
          end
        end
      end
    end
  end
end
