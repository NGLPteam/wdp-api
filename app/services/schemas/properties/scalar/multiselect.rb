# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Multiselect < Base
        include HasSelectOptions
        include ValidatesSize

        attribute :default, :string_array

        array! :str?

        schema_type! :string

        config.graphql_value_key = :selections

        def add_to_rules!(context)
          super

          prop = self

          context.rule(full_path).each do
            key.failure("must be a known option") unless value.in? prop.option_values
          end
        end

        def build_array_element_predicates
          super.merge(
            included_in?: option_values
          )
        end
      end
    end
  end
end
