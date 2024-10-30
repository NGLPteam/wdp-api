# frozen_string_literal: true

module Templates
  module Compositions
    class Slot < Shale::Mapper
      attribute :name, ::Mappers::StrippedString
      attribute :default_template, ::Mappers::StrippedString
      attribute :description, ::Mappers::StrippedString
      attribute :slot_kind, Templates::Compositions::SlotKind, default: -> { "inline" }
      attribute :template_kind, Templates::Compositions::TemplateKind

      xml do
        root "slot"

        map_attribute "name", to: :name
        map_attribute "kind", to: :slot_kind
        map_element "description", to: :description
        map_element "default-template", to: :default_template, cdata: true
      end
    end
  end
end
