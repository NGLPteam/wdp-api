# frozen_string_literal: true

module Types
  module SearchableType
    include Types::BaseInterface

    field :search, Types::SearchScopeType, null: false do
      description "Search from this level of the API using it as the origin"

      argument :max_depth, Integer, required: false do
        description <<~TEXT
        When searching from a scoped entity, sometimes you want to limit the depth of the search.

        `maxDepth: 1` will restrict to just the entity's direct children (or direct links).
        TEXT
      end

      argument :visibility, Types::EntityVisibilityFilterType, default_value: :visible, required: false do
        description <<~TEXT
        Restrict the results by a certain level of visibility. This requires an authenticated user
        for anything but `VISIBLE`: any other option will be silently discarded when anonymous.
        TEXT
      end
    end

    # @return [Searching::Scope]
    def search(visibility:, max_depth: nil)
      options = {
        origin: search_origin,
        max_depth: max_depth,
        visibility: visibility,
        user: context[:current_user]
      }

      ::Searching::Scope.new options
    end

    # @see Searching::Origin
    # @return [Searching::Types::OriginModel]
    def search_origin
      object
    end
  end
end
