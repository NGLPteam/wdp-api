# frozen_string_literal: true

module Types
  # @see SchemaVersion
  class SchemaVersionType < Types::AbstractModel
    description <<~TEXT
    A specific version of a `SchemaDefinition`.
    TEXT

    implements Types::DescribesSchemaType
    implements Types::SearchableType
    implements HasSchemaPropertiesType

    field :schema_definition, Types::SchemaDefinitionType, null: false,
      description: "The shared schema definition for all versions of this namespace and identifier"

    field :number, String, null: false,
      description: "A semantic version for the schema"

    field :core, Types::SchemaCoreDefinitionType, null: false,
      description: "Configuration for controlling how instances of a schema handle certain optional core properties."

    field :render, Types::SchemaRenderDefinitionType, null: false,
      description: "Configuration for rendering schema instances outside of orderings"

    field :searchable_properties, [Types::AnySearchablePropertyType, { null: false }], null: false do
      description "A subset of properties that can be searched for this schema."
    end

    field :enforced_parent_declarations, [Types::SlugType, { null: false }], null: false do
      description <<~TEXT
      Declarations / slugs for `enforcedParentVersions`.
      TEXT
    end

    field :enforced_parent_versions, [Types::SchemaVersionType, { null: false }], null: false do
      description <<~TEXT
      The versions that are allowed to parent this schema.

      If there are no schemas, then this schema does not enforce its parentage.
      TEXT
    end

    field :enforced_child_declarations, [Types::SlugType, { null: false }], null: false do
      description <<~TEXT
      Declarations / slugs for `enforcedChildVersions`.
      TEXT
    end

    field :enforced_child_versions, [Types::SchemaVersionType, { null: false }], null: false do
      description <<~TEXT
      The versions that this schema accepts as a child.

      If there are no schemas, then this schema does not enforce its children.
      TEXT
    end

    field :enforces_parent, Boolean, null: false do
      description "A boolean for the logic on `enforcedParentVersions`."
    end

    field :enforces_children, Boolean, null: false do
      description "A boolean for the logic on `enforcedChildVersions`."
    end

    def enforced_parent_versions
      Support::Loaders::AssociationLoader.for(object.class, :enforced_parent_versions).load(object)
    end

    def enforced_child_versions
      Support::Loaders::AssociationLoader.for(object.class, :enforced_child_versions).load(object)
    end

    # @see Schemas::Versions::Configuration#core
    # @return [Schemas::Versions::CoreDefinition]
    def core
      object.configuration.core
    end

    # @see Schemas::Versions::Configuration#render
    # @return [Schemas::Versions::RenderDefinition]
    def render
      object.configuration.render
    end

    def slug
      object.declaration
    end
  end
end
