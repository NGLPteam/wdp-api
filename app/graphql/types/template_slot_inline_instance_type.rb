# frozen_string_literal: true

module Types
  class TemplateSlotInlineInstanceType < Types::BaseObject
    description <<~TEXT
    An inline template slot that has been rendered.

    Its `kind` will always be `INLINE`.
    TEXT

    implements Types::TemplateSlotInstanceType
  end
end
