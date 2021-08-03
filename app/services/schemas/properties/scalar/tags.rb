# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Tags < Base
        include ValidatesSize

        attribute :default, :string_array

        array! :str?

        schema_type! :string

        def add_to_rules!(context)
          super

          context.rule(full_path).each(:tag_format)
        end
      end
    end
  end
end
