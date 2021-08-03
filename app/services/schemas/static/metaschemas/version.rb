# frozen_string_literal: true

module Schemas
  module Static
    module Metaschemas
      class Version < Schemas::Static::Version
        memoize def schemer
          JSONSchemer.schema raw_data, format: true, insert_property_defaults: true
        end

        # @return [Dry::Monads::Result]
        def validate(value)
          errors = schemer.validate(value).to_a

          return Success(value) if errors.blank?

          Failure[:invalid_schema, { schema: value, errors: errors }]
        end
      end
    end
  end
end
