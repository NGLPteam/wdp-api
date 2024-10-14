# frozen_string_literal: true

module Types
  class TemplateSlotKindType < Types::BaseEnum
    description <<~TEXT
    An enum discriminating between different types of content.
    TEXT

    value "BLOCK", value: "block" do
      description <<~TEXT
      A template slot containing lengthier content that may wrap, contain semantic newlines / paragraphs, etc.
      TEXT
    end

    value "INLINE", value: "inline" do
      description <<~TEXT
      A template slot containing only inline information. It should contain no block level tags.

      It is intended for use in header, list item, and generally any other short-form spans of content.
      TEXT
    end
  end
end
