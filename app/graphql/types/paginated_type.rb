# frozen_string_literal: true

module Types
  module PaginatedType
    include Types::BaseInterface

    description "Connections can be paginated by cursor or number."

    field :page_info, Types::PageInfoType, null: false, description: "Information to aid in pagination."
  end
end
