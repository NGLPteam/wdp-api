# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class String < Base
        include ValidatesSize

        attribute :pattern, :string
        attribute :default, :string

        orderable!

        schema_type! :string

        def add_to_rules!(context)
          super

          context.rule(full_path) do
            key.failure(:filled?) if value.blank?
          end
        end
      end
    end
  end
end
