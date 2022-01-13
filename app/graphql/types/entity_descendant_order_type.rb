# frozen_string_literal: true

module Types
  # @note For performance and usage reasons, this does not support quite as much as {Types::EntityOrderType}.
  class EntityDescendantOrderType < Types::BaseEnum
    description "Sort entity descendants by specific attributes and order"

    value "PUBLISHED_ASCENDING", description: "Sort descendants by oldest published date (or OLDEST for communities)"
    value "PUBLISHED_DESCENDING", description: "Sort descendants by newest published date (or RECENT for communities)"
    value "TITLE_ASCENDING", description: "Sort descendants by title A-Z"
    value "TITLE_DESCENDING", description: "Sort descendants by title Z-A"
  end
end
