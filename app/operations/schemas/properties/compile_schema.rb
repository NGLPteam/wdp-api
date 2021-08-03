# frozen_string_literal: true

module Schemas
  module Properties
    class CompileSchema
      include Dry::Monads[:result]

      # @param [<Schemas::Properties::BaseDefinition>] properties
      # @return [Dry::Monads::Result::Success(Dry::Schema::Params)]
      # @return [Dry::Monads::Result::Failure]
      def call(properties)
        schema = Dry::Schema.Params do
          properties.each do |property|
            property.add_to_schema! self
          end

          before(:value_coercer) do |result|
            values = result.to_h || {}

            values.tap do |h|
              properties.each do |property|
                next if property.group?

                next unless property.might_normalize_value_before_coercion?

                context = {
                  raw: h[property.key],
                  specified: h.key?(property.key),
                }

                h[property.key] = property.normalize_schema_value_before_coercer(context)
              end
            end
          end
        end

        Success schema
      end
    end
  end
end
