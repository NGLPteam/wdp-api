# frozen_string_literal: true

module Types
  module TemplateSlotDefinitionType
    include Types::BaseInterface

    description <<~TEXT
    A slot definition describes how the slot should be rendered with a template.
    TEXT

    field :raw_template, String, null: true do
      description <<~TEXT
      The liquid template to render.
      TEXT
    end

    field :kind, Types::TemplateSlotKindType, null: false do
      description <<~TEXT
      The kind of slot instance this is.
      TEXT
    end
  end
end