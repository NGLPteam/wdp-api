# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Markdown < Base
        include ValidatesSize

        attribute :default, :string

        schema_type! :string

        config.always_wide = true
      end
    end
  end
end
