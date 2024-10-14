# frozen_string_literal: true

module Types
  module RenderableType
    include Types::BaseInterface

    description <<~TEXT
    An interface describing an instance type that can be rendered for a given entity.
    TEXT

    field :last_rendered_at, GraphQL::Types::ISO8601DateTime, null: true do
      description <<~TEXT
      The time this object was last rendered.
      TEXT
    end
  end
end
