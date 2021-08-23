# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the WDP API.
    TEXT

    field :alter_schema_version, mutation: Mutations::AlterSchemaVersion

    field :apply_schema_properties, mutation: Mutations::ApplySchemaProperties

    field :create_asset, mutation: Mutations::CreateAsset

    field :create_collection, mutation: Mutations::CreateCollection

    field :create_community, mutation: Mutations::CreateCommunity

    field :create_item, mutation: Mutations::CreateItem

    field :create_ordering, mutation: Mutations::CreateOrdering

    field :create_organization_contributor, mutation: Mutations::CreateOrganizationContributor

    field :create_person_contributor, mutation: Mutations::CreatePersonContributor

    field :create_role, mutation: Mutations::CreateRole

    field :destroy_contributor, mutation: Mutations::DestroyContributor

    field :destroy_ordering, mutation: Mutations::DestroyOrdering

    field :grant_access, mutation: Mutations::GrantAccess

    field :link_entity, mutation: Mutations::LinkEntity

    field :reparent_collection, mutation: Mutations::ReparentCollection

    field :reparent_item, mutation: Mutations::ReparentItem

    field :reset_ordering, mutation: Mutations::ResetOrdering

    field :revoke_access, mutation: Mutations::RevokeAccess

    field :update_collection, mutation: Mutations::UpdateCollection

    field :update_community, mutation: Mutations::UpdateCommunity

    field :update_item, mutation: Mutations::UpdateItem

    field :update_ordering, mutation: Mutations::UpdateOrdering

    field :update_organization_contributor, mutation: Mutations::UpdateOrganizationContributor

    field :update_person_contributor, mutation: Mutations::UpdatePersonContributor

    field :update_role, mutation: Mutations::UpdateRole
  end
end
