# frozen_string_literal: true

module Types
  module Schematic
    module OptionablePropertyType
      include ::Types::BaseInterface

      field :options, [SelectOptionType, { null: false }], null: false
    end
  end
end
