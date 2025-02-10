# frozen_string_literal: true

module Types
  class SiblingKindType < Types::BaseEnum
    description <<~TEXT
    The directionality of a sibling relationship, relative to a specific record (referred to as the 'source').
    TEXT

    value "PREV", value: "prev" do
      description <<~TEXT
      This sibling comes before the source record.
      TEXT
    end

    value "NEXT", value: "next" do
      description <<~TEXT
      This sibling comes after the source record.
      TEXT
    end
  end
end
