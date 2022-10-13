# frozen_string_literal: true

module PilotHarvesting
  # @abstract
  class CollectionDefinition < Struct
    include Dry::Effects.Resolve(:community)
    include PilotHarvesting::Harvestable

    defines :schema_name, type: Types::String

    schema_name "default:collection"

    attribute :identifier, Types::String

    attribute :title, Types::String

    attribute? :subtitle, Types::String.optional.default(nil)

    attribute? :issn, Types::String.optional.default(nil)

    delegate :schema_name, to: :class

    def upsert
      provide default_collection_schema: schema do
        call_operation("collections.upsert", identifier, title: title, parent: collection_parent, issn: issn, properties: properties) do |collection|
          upsert_source_for! collection
        end
      end
    end

    def collection_parent
      community
    end

    def properties
      {}
    end

    # @!attribute [r] schema
    # @return [SchemaVersion]
    def schema
      find_schema schema_name
    end
  end
end
