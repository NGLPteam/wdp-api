# frozen_string_literal: true

module Types
  class LinkTargetCandidateType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    global_id_field :id

    description "A candidate for a link target, scoped to a parent source"

    field :target, "Types::AnyLinkTargetType", null: false,
      description: "The actual target"

    field :kind, Types::LinkTargetCandidateKindType, null: false,
      method: :target_type

    field :title, String, null: false,
      description: "The target entity's title"

    field :depth, Integer, null: false,
      description: "How deeply nested the candidate entity is"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
