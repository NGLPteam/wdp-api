# frozen_string_literal: true

module Templates
  module Definitions
    class Slot < Shale::Mapper
      attribute :name, ::Mappers::StrippedString
      attribute :default_template, Templates::Definitions::SlotTemplate
      attribute :description, ::Mappers::StrippedString
      attribute :slot_kind, Templates::Definitions::SlotKind, default: -> { "inline" }
      attribute :template_kind, Templates::Definitions::TemplateKind

      xml do
        root "slot"

        map_attribute "kind", to: :slot_kind
        map_element "description", to: :description
        map_element "template", to: :default_template
      end
    end
  end
end
