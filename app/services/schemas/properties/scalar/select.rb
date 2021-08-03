# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Select < Base
        include HasSelectOptions

        attribute :default, :string
        attribute :options, SelectOption.to_array_type, default: proc { [] }

        schema_type! :string

        def base_schema_predicates
          super().merge(included_in?: option_values)
        end

        def add_to_rules!(context)
          super

          prop = self

          context.rule(full_path) do
            key.failure("must be a known option") unless value.in?(prop.option_values)
          end
        end
      end
    end
  end
end
