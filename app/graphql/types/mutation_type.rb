# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_asset, mutation: Mutations::CreateAsset

    field :create_collection, mutation: Mutations::CreateCollection

    field :create_community, mutation: Mutations::CreateCommunity

    field :create_item, mutation: Mutations::CreateItem

    field :create_role, mutation: Mutations::CreateRole

    field :grant_access, mutation: Mutations::GrantAccess

    field :revoke_access, mutation: Mutations::RevokeAccess

    field :update_community, mutation: Mutations::UpdateCommunity

    field :update_role, mutation: Mutations::UpdateRole
  end
end
