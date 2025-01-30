# frozen_string_literal: true

module Types
  module ContributorType
    include Types::BaseInterface

    description <<~TEXT
    An interface for an abstract contributor who has made a contribution.

    See `kind` for what type it is.

    This type builds on `ContributorBase` by adding
    the ability to fetch contributions to collections and items.
    TEXT

    implements Types::ContributorBaseType

    field :attributions, resolver: Resolvers::ContributorAttributionResolver, connection: true

    field :collection_contributions, resolver: Resolvers::CollectionContributionResolver, connection: true

    field :item_contributions, resolver: Resolvers::ItemContributionResolver, connection: true
  end
end
