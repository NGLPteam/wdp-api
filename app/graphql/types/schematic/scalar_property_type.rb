# frozen_string_literal: true

module Types
  module Schematic
    module ScalarPropertyType
      include Types::BaseInterface

      include SchemaPropertyType

      field :label, String, null: false
      field :required, Boolean, null: false
      field :is_wide, Boolean, null: false, method: :wide?

      def label
        object.label.presence || object.path.titleize
      end

      def required
        object.required.present?
      end
    end
  end
end
