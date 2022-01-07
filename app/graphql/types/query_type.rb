# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description <<~TEXT
    The entry point for retrieving data from within the WDP API.
    TEXT

    add_field GraphQL::Types::Relay::NodeField

    add_field GraphQL::Types::Relay::NodesField

    field :access_grants, resolver: Resolvers::AccessGrantResolver,
      description: "Retrieve all access grants"

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

    field :user, Types::UserType, null: true do
      description "Look up a user by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :users, resolver: Resolvers::UserResolver do
      description "A list of all users in the system"
    end

    field :viewer, Types::UserType, null: false,
      description: "The currently authenticated user. AKA: you"

    def asset(slug:)
      Loaders::RecordLoader.for(Asset).load(slug)
    end

    def collection(slug:)
      Loaders::RecordLoader.for(Collection).load(slug)
    end

    def collection_contribution(slug:)
      Loaders::RecordLoader.for(CollectionContribution).load(slug)
    end

    def community(slug:)
      Loaders::RecordLoader.for(Community).load(slug)
    end

    def contributor(slug:)
      Loaders::RecordLoader.for(Contributor).load(slug)
    end

    # @return [GlobalConfiguration]
    def global_configuration
      GlobalConfiguration.fetch
    end

    def item(slug:)
      Loaders::RecordLoader.for(Item).load(slug)
    end

    def item_contribution(slug:)
      Loaders::RecordLoader.for(ItemContribution).load(slug)
    end

    # @see Schemas::Orderings::PathOptions::Fetch
    # @param [<Hash>] schemas (@see Schemas::Associations::OrderingFilter)
    # @return [<Schemas::Orderings::PathOptions::Reader>]
    def ordering_paths(schemas: [])
      call_operation! "schemas.orderings.path_options.fetch", schemas: schemas
    end

    # @param [String] slug
    # @return [SchemaDefinition, nil]
    def schema_definition(slug:)
      WDPAPI::Container["schemas.definitions.find"].call(slug).value_or(nil)
    end

    # @param [String] slug
    # @return [SchemaVersion, nil]
    def schema_version(slug:)
      WDPAPI::Container["schemas.versions.find"].call(slug).value_or(nil)
    end

    # @param [String] slug
    # @return [User, nil]
    def user(slug:)
      Loaders::RecordLoader.for(User, column: :keycloak_id).load(slug)
    end

    def viewer
      context[:current_user] || AnonymousUser.new
    end
  end
end
