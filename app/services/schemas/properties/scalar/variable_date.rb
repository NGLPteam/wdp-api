# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class VariableDate < Base
        schema_type! AppTypes.Instance(VariablePrecisionDate)

        def might_normalize_value_before_coercion?
          true unless exclude_from_schema?
        end

        def normalize_schema_value_before_coercer(raw:, **)
          VariablePrecisionDate.parse raw
        end
      end
    end
  end
end
