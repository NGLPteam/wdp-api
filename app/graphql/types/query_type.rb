# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description <<~TEXT
    The entry point for retrieving data from within the Meru API.
    TEXT

    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    implements Types::QueriesControlledVocabulary
    implements Types::QueriesControlledVocabularySource
    implements Types::SearchableType

    field :access_grants, resolver: Resolvers::AccessGrantResolver,
      description: "Retrieve all access grants"

    field :analytics, Types::AnalyticsType, null: false do
      description "Access top-level analytics."
    end

    field :asset, Types::AnyAssetType, null: true do
      description "Look up an asset by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :collection, Types::CollectionType, null: true do
      description "Look up a collection by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :collection_contribution, Types::CollectionContributionType, null: true do
      description "Look up a collection contribution by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :communities, resolver: Resolvers::CommunityResolver do
      description "List all communities"
    end

    field :community, Types::CommunityType, null: true do
      description "Look up a community by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :community_by_title, Types::CommunityType, null: true do
      description "Look up a community by its title"

      argument :title, String, required: true
    end

    field :item, Types::ItemType, null: true do
      description "Look up an item by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :item_contribution, Types::ItemContributionType, null: true do
      description "Look up an item contribution by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :contributor, Types::AnyContributorType, null: true do
      description "Look up a contributor by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :contributor_lookup, Types::AnyContributorType, null: true do
      description <<~TEXT
      Look up a contributor `by` a certain `value`.
      TEXT

      argument :by, Types::ContributorLookupFieldType, required: true, as: :field do
        description <<~TEXT
        The field to search a contributor with. Unless otherwise specified, the provided
        `value` will be an exact match.
        TEXT
      end

      argument :value, String, required: true do
        description <<~TEXT
        The actual value to look a contributor up `by`.
        TEXT
      end

      argument :order, Types::SimpleOrderType, required: true, default_value: "RECENT" do
        description <<~TEXT
        For certain fields, the values are not guaranteed to be unique. In these instances,
        the *most recently* created contributor will be selected by default. If the first
        is preferred, specify `order: OLDEST`.
        TEXT
      end
    end

    field :contribution_roles, Types::ContributionRoleConfigurationType, null: false do
      description "Look up contribution role configuration for a given contributable (or globally)."

      argument :contributable_id, ID, loads: Types::ContributableType, required: false do
        description "The contributable to load for, if applicable."
      end
    end

    field :contributors, resolver: Resolvers::ContributorResolver do
      description "A list of all contributors in the system"
    end

    field :global_configuration, Types::GlobalConfigurationType, null: false do
      description "Fetch the global configuration for this installation"
    end

    field :ordering_paths, [Types::AnyOrderingPathType, { null: false }], null: false do
      description "A list of ordering paths for creating and updating orderings."

      argument :schemas, [Types::OrderingSchemaFilterInputType, { null: false }], required: false do
        description "If passed, this will restrict the property fields returned to the selected schemas."
      end
    end

    field :roles, resolver: Resolvers::RoleResolver do
      description "List all roles"
    end

    field :schema_definition, Types::SchemaDefinitionType, null: true do
      description "Look up a schema definition by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :schema_definitions, resolver: Resolvers::SchemaDefinitionResolver do
      description "List all schema definitions"
    end

    field :schema_version, Types::SchemaVersionType, null: true do
      description "Look up a schema version by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :schema_versions, resolver: Resolvers::SchemaVersionResolver do
      description "List all schema versions"
    end

    field :schema_version_options, resolver: Resolvers::SchemaVersionOptionResolver do
      description "List all options for schema versions"
    end

    field :system_info, Types::SystemInfoType, null: false do
      description "A helper field that is used to look up various details about the WDP-API ecosystem."
    end

    field :user, Types::UserType, null: true do
      description "Look up a user by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :users, resolver: Resolvers::UserResolver do
      description "A list of all users in the system"
    end

    field :viewer, Types::UserType, null: false,
      description: "The currently authenticated user. AKA: you"

    # @return [void]
    def analytics
      {}
    end

    def asset(slug:)
      Support::Loaders::RecordLoader.for(Asset).load(slug)
    end

    def collection(slug:)
      Support::Loaders::RecordLoader.for(Collection).load(slug).tap do |collection|
        track_entity_event! collection
      end
    end

    def collection_contribution(slug:)
      Support::Loaders::RecordLoader.for(CollectionContribution).load(slug)
    end

    def community(slug:)
      Support::Loaders::RecordLoader.for(Community).load(slug).tap do |community|
        track_entity_event! community
      end
    end

    # @param [String] title
    # @return [Community, nil]
    def community_by_title(title:)
      Community.by_title(title).first.tap do |community|
        track_entity_event! community
      end
    end

    # @param [Contributable, nil] contributable
    # @return [ContributionRoleConfiguration]
    def contribution_roles(contributable: nil)
      call_operation("contribution_roles.fetch_config", contributable:).value_or(nil)
    end

    def contributor(slug:)
      Support::Loaders::RecordLoader.for(Contributor).load(slug)
    end

    def contributor_lookup(**options)
      call_operation "contributors.lookup", **options do |m|
        m.success do |contributor|
          contributor
        end

        m.failure(:invalid) do |_, reason|
          raise GraphQL::ExecutionError, "An error occurred when looking up a contributor: #{reason}"
        end

        m.failure do
          # :nocov:
          raise GraphQL::ExecutionError, "Something went wrong with contributor lookup"
          # :nocov:
        end
      end
    end

    # @return [GlobalConfiguration]
    def global_configuration
      GlobalConfiguration.fetch
    end

    def item(slug:)
      Support::Loaders::RecordLoader.for(Item).load(slug).tap do |item|
        track_entity_event! item
      end
    end

    def item_contribution(slug:)
      Support::Loaders::RecordLoader.for(ItemContribution).load(slug)
    end

    # @see Schemas::Orderings::PathOptions::Fetch
    # @param [<Hash>] schemas (@see Schemas::Associations::OrderingFilter)
    # @return [<Schemas::Orderings::PathOptions::Reader>]
    def ordering_paths(schemas: [])
      call_operation! "schemas.orderings.path_options.fetch", schemas:
    end

    # @param [String] slug
    # @return [SchemaDefinition, nil]
    def schema_definition(slug:)
      MeruAPI::Container["schemas.definitions.find"].call(slug).value_or(nil)
    end

    # @param [String] slug
    # @return [SchemaVersion, nil]
    def schema_version(slug:)
      MeruAPI::Container["schemas.versions.find"].call(slug).value_or(nil)
    end

    def system_info
      viewer
    end

    # @param [String] slug
    # @return [User, nil]
    def user(slug:)
      Support::Loaders::RecordLoader.for(User, column: :keycloak_id).load(slug)
    end

    def viewer
      context[:current_user] || AnonymousUser.new
    end

    def search_origin
      :global
    end
  end
end
