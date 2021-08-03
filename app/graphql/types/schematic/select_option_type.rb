# frozen_string_literal: true

module Types
  module Schematic
    class SelectOptionType < Types::BaseObject
      field :label, String, null: false
      field :value, String, null: false
    end
  end
end
