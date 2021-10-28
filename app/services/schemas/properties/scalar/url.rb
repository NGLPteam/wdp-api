# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class URL < Base
        schema_type! AppTypes::SchemaURL

        def might_normalize_value_before_coercion?
          true unless exclude_from_schema?
        end

        def normalize_schema_value_before_coercer(raw:, **)
          case raw
          when AppTypes::SchemaURL
            AppTypes::SchemaURL[raw]
          when String
            { href: raw, label: "URL", title: "" }
          end
        end
      end
    end
  end
end
