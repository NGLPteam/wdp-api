# frozen_string_literal: true

module Types
  module Schematic
    module SchemaPropertyType
      include Types::BaseInterface

      field :full_path, String, null: false
      field :path, String, null: false
      field :type, String, null: false
    end
  end
end
