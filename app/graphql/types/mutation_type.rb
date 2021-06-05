# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the WDP API.
    TEXT

    field :create_asset, mutation: Mutations::CreateAsset

    field :create_collection, mutation: Mutations::CreateCollection

    field :create_community, mutation: Mutations::CreateCommunity

    field :create_item, mutation: Mutations::CreateItem

    field :create_role, mutation: Mutations::CreateRole

    field :grant_access, mutation: Mutations::GrantAccess

    field :reparent_collection, mutation: Mutations::ReparentCollection

    field :reparent_item, mutation: Mutations::ReparentItem

    field :revoke_access, mutation: Mutations::RevokeAccess

    field :update_collection, mutation: Mutations::UpdateCollection

    field :update_community, mutation: Mutations::UpdateCommunity

    field :update_item, mutation: Mutations::UpdateItem

    field :update_role, mutation: Mutations::UpdateRole
  end
end
