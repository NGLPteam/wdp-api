# frozen_string_literal: true

module Types
  class ItemType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    global_id_field :id

    description "An item that belongs to a collection"

    field :collection, Types::CollectionType, null: false
    field :title, String, null: false
    field :description, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
