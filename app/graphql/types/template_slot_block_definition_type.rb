# frozen_string_literal: true

module Types
  class TemplateSlotBlockDefinitionType < Types::BaseObject
    description <<~TEXT
    A definition for a block-type template slot.

    Its `kind` will always be `BLOCK`.
    TEXT

    implements Types::TemplateSlotDefinitionType
  end
end
