# frozen_string_literal: true

module Types
  class URLReferenceType < Types::BaseObject
    description "A representation of a URL suitable for creating anchor tags"

    field :href, String, null: true,
      description: "The actual URL"

    field :label, String, null: true,
      description: "A label to display within the text content of the anchor tag"

    field :title, String, null: true,
      description: "A title to display when mousing over the URL"
  end
end
