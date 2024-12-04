# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the WDP API.
    TEXT

    field :alter_schema_version, mutation: Mutations::AlterSchemaVersion

    field :apply_schema_properties, mutation: Mutations::ApplySchemaProperties

    field :controlled_vocabulary_destroy, mutation: Mutations::ControlledVocabularyDestroy

    field :controlled_vocabulary_source_update, mutation: Mutations::ControlledVocabularySourceUpdate

    field :controlled_vocabulary_upsert, mutation: Mutations::ControlledVocabularyUpsert

    field :clear_initial_ordering, mutation: Mutations::ClearInitialOrdering

    field :create_announcement, mutation: Mutations::CreateAnnouncement

    field :create_asset, mutation: Mutations::CreateAsset

    field :create_collection, mutation: Mutations::CreateCollection

    field :create_community, mutation: Mutations::CreateCommunity

    field :create_item, mutation: Mutations::CreateItem

    field :create_ordering, mutation: Mutations::CreateOrdering

    field :create_organization_contributor, mutation: Mutations::CreateOrganizationContributor

    field :create_page, mutation: Mutations::CreatePage

    field :create_person_contributor, mutation: Mutations::CreatePersonContributor

    field :create_role, mutation: Mutations::CreateRole

    field :destroy_announcement, mutation: Mutations::DestroyAnnouncement

    field :destroy_asset, mutation: Mutations::DestroyAsset

    field :destroy_collection, mutation: Mutations::DestroyCollection

    field :destroy_community, mutation: Mutations::DestroyCommunity

    field :destroy_contribution, mutation: Mutations::DestroyContribution

    field :destroy_contributor, mutation: Mutations::DestroyContributor

    field :destroy_entity_link, mutation: Mutations::DestroyEntityLink

    field :destroy_item, mutation: Mutations::DestroyItem

    field :destroy_ordering, mutation: Mutations::DestroyOrdering

    field :destroy_page, mutation: Mutations::DestroyPage

    field :grant_access, mutation: Mutations::GrantAccess

    field :link_entity, mutation: Mutations::LinkEntity

    field :reparent_entity, mutation: Mutations::ReparentEntity

    field :reset_ordering, mutation: Mutations::ResetOrdering

    field :revoke_access, mutation: Mutations::RevokeAccess

    field :select_initial_ordering, mutation: Mutations::SelectInitialOrdering

    field :update_announcement, mutation: Mutations::UpdateAnnouncement

    field :update_asset, mutation: Mutations::UpdateAsset

    field :update_asset_attachment, mutation: Mutations::UpdateAssetAttachment

    field :update_collection, mutation: Mutations::UpdateCollection

    field :update_community, mutation: Mutations::UpdateCommunity

    field :update_contribution, mutation: Mutations::UpdateContribution

    field :update_item, mutation: Mutations::UpdateItem

    field :update_global_configuration, mutation: Mutations::UpdateGlobalConfiguration

    field :update_ordering, mutation: Mutations::UpdateOrdering

    field :update_organization_contributor, mutation: Mutations::UpdateOrganizationContributor

    field :update_page, mutation: Mutations::UpdatePage

    field :update_person_contributor, mutation: Mutations::UpdatePersonContributor

    field :update_role, mutation: Mutations::UpdateRole

    field :update_user, mutation: Mutations::UpdateUser

    field :update_viewer_settings, mutation: Mutations::UpdateViewerSettings

    field :upsert_contribution, mutation: Mutations::UpsertContribution

    field :render_layouts, mutation: Mutations::RenderLayouts

    field :preview_slot, mutation: Mutations::PreviewSlot
  end
end
