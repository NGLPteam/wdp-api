# frozen_string_literal: true

module Types
  class EntityOrderType < Types::BaseEnum
    description "Sort entities by a specific property and order"

    value "RECENT", description: "Sort entities by newest created date"
    value "OLDEST", description: "Sort entities by oldest created date"
    value "PUBLISHED_ASCENDING", description: "Sort entities by oldest published date (or OLDEST for communities)"
    value "PUBLISHED_DESCENDING", description: "Sort entities by newest published date (or RECENT for communities)"
    value "TITLE_ASCENDING", description: "Sort entities by title A-Z"
    value "TITLE_DESCENDING", description: "Sort entities by title Z-A"
    value "SCHEMA_NAME_ASCENDING", description: "Sort entities by the name of their schema A-Z"
    value "SCHEMA_NAME_DESCENDING", description: "Sort entities by the name of their schema Z-A"
  end
end
