# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class String < Base
        include ValidatesSize

        attribute :pattern, :string
        attribute :default, :string

        schema_type! :string
      end
    end
  end
end
