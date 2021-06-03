# frozen_string_literal: true

module Types
  module AttachableType
    include Types::BaseInterface

    description "A model that has attached assets"

    field :assets, resolver: Resolvers::AssetResolver, description: "Assets owned by this entity"
  end
end
