# frozen_string_literal: true

module Types
  class TemplateSlotInlineDefinitionType < Types::BaseObject
    description <<~TEXT
    A definition for an inline-type template slot.

    Its `kind` will always be `INLINE`.
    TEXT

    implements Types::TemplateSlotDefinitionType
  end
end
