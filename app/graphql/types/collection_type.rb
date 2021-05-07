# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    implements Types::Sluggable

    global_id_field :id

    description "A collection"

    field :title, String, null: false
    field :description, String, null: false

    field :items, resolver: Resolvers::ItemResolver

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
