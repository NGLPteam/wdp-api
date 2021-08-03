# frozen_string_literal: true

module Types
  module Schematic
    module ScalarPropertyType
      include Types::BaseInterface

      include SchemaPropertyType

      field :label, String, null: true
      field :required, Boolean, null: true
    end
  end
end
