# frozen_string_literal: true

module Types
  # @see SchemaVersion
  class SchemaVersionType < Types::AbstractModel
    description <<~TEXT
    A specific version of a `SchemaDefinition`.
    TEXT

    implements Types::DescribesSchemaType
    implements HasSchemaPropertiesType

    field :schema_definition, Types::SchemaDefinitionType, null: false,
      description: "The shared schema definition for all versions of this namespace and identifier"

    field :number, String, null: false,
      description: "A semantic version for the schema"

    field :core, Types::SchemaCoreDefinitionType, null: false,
      description: "Configuration for controlling how instances of a schema handle certain optional core properties."

    field :render, Types::SchemaRenderDefinitionType, null: false,
      description: "Configuration for rendering schema instances outside of orderings"

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
