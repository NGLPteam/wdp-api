# frozen_string_literal: true

module Types
  class TemplateSlotBlockInstanceType < Types::BaseObject
    description <<~TEXT
    A block template slot that has been rendered.

    Its `kind` will always be `BLOCK`.
    TEXT

    implements Types::TemplateSlotInstanceType
  end
end
