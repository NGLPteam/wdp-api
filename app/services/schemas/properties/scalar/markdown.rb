# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Markdown < Base
        include ValidatesSize

        always_wide!

        fillable!

        schema_type! :string

        attribute :default, :string
      end
    end
  end
end
