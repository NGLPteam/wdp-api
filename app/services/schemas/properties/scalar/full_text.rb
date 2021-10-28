# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      # @see SchematicText
      class FullText < Base
        schema_type! AppTypes::FullTextReference

        config.always_wide = true

        def extract_raw_value_from(context)
          context.full_text(full_path)
        end

        def might_normalize_value_before_coercion?
          true unless exclude_from_schema?
        end

        def normalize_schema_value_before_coercer(raw:, **)
          WDPAPI::Container["full_text.normalizer"].call raw
        end

        def write_values_within!(context)
          context.write_full_text! path
        end
      end
    end
  end
end
