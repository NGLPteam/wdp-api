# frozen_string_literal: true

module Types
  # @see Schemas::Properties::Context
  class SchemaInstanceContextType < Types::BaseObject
    description "A context that describes the current state of the form"

    field :assets, [Types::AssetSelectOptionType, { null: false }], null: false

    field :contributors, [Types::ContributorSelectOptionType, { null: false }], null: false

    field :default_values, GraphQL::Types::JSON, null: false,
      description: "Not yet populated. May be used in the future."

    field :entity_id, ID, null: false,
      description: "The entity ID for this schema instance."

    field :field_values, GraphQL::Types::JSON, null: false,
      description: "The values for the schema form on this instance"

    field :schema_version_slug, String, null: false,
      description: "The slug for the current schema version"

    field :validity, Types::SchemaInstanceValidationType, null: true,
      description: "Information about the validity of the schema instance"

    # @return [<Hash>]
    def assets
      instance = object.instance

      return [] if instance.blank?

      Loaders::AssociationLoader.for(instance.class, :assets).load(instance).then do |assets|
        assets.map(&:to_schematic_referent_option)
      end
    end

    # @return [<Hash>]
    def contributors
      if object.has_contributors?
        Contributor.all.map(&:to_schematic_referent_option)
      else
        []
      end
    end

    # @return [String]
    def entity_id
      object.instance.to_encoded_id
    end

    # @return [String]
    def schema_version_slug
      object.instance.schema_version.system_slug
    end

    # @see Schemas::Instances::Validate
    # @return [Hash, nil]
    def validity
      instance = object.instance

      return nil if instance.blank?

      call_operation! "schemas.instances.validate", instance, context: object
    end
  end
end
