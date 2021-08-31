# frozen_string_literal: true

module Types
  module HierarchicalEntryType
    include Types::BaseInterface

    description "A hierarchical entry, like a collection or an item."

    field :identifier, String, null: false
    field :title, String, null: true
    field :doi, String, null: true
    field :summary, String, null: true

    field :published_on, GraphQL::Types::ISO8601Date, null: true
    field :visible_after_at, GraphQL::Types::ISO8601DateTime, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :root, Boolean, null: false, method: :root?
    field :leaf, Boolean, null: false, method: :leaf?
  end
end
