# frozen_string_literal: true

module Types
  class FullTextType < Types::BaseObject
    description "A full-text searchable value for an entity"

    field :content, String, null: true,
      description: "The full-text searchable value itself"

    field :kind, Types::FullTextKindType, null: true,
      description: "The content type for the text, if any"

    field :lang, String, null: true,
      description: "The ISO-639 language code of this content, if any"
  end
end
