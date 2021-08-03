# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Boolean < Base
        attribute :default, :boolean

        schema_type! :bool
      end
    end
  end
end
