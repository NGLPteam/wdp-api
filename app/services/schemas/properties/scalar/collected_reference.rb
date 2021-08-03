# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module CollectedReference
        extend ActiveSupport::Concern

        include Reference

        included do
          array!
        end

        def extract_raw_value_from(context)
          context.collected_reference(full_path)
        end

        def write_values_within!(context)
          context.write_collected_references! path
        end

        def build_array_element_predicates
          super.merge(case?: config.base_type)
        end
      end
    end
  end
end
