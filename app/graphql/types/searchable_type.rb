# frozen_string_literal: true

module Types
  module SearchableType
    include Types::BaseInterface

    field :search, Types::SearchScopeType, null: false do
      description "Search from this level of the API using it as the origin"

      argument :visibility, Types::EntityVisibilityFilterType, default_value: :visible, required: false do
        description <<~TEXT
        Restrict the results by a certain level of visibility. This requires an authenticated user
        for anything but `VISIBLE`: any other option will be silently discarded when anonymous.
        TEXT
      end
    end

    # @return [Searching::Scope]
    def search(visibility:)
      options = {
        origin: search_origin,
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
