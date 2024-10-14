# frozen_string_literal: true

module Types
  module TemplateSlotInstanceType
    include Types::BaseInterface

    description <<~TEXT
    A slot instance is an actual rendered
    property that may appear in a template.
    TEXT

    field :content, String, null: true do
      description <<~TEXT
      The actual rendered content for the template (if available).
      TEXT
    end

    field :kind, Types::TemplateSlotKindType, null: false do
      description <<~TEXT
      The kind of slot instance this is.
      TEXT
    end

    field :errors, [String, { null: false }], null: true do
      description <<~TEXT
      Any errors for this slot that occurred during rendering, if applicable.
      TEXT
    end

    field :valid, Boolean, null: false do
      description <<~TEXT
      Whether this slot rendered successfully (i.e. had no errors).
      TEXT
    end
  end
end
