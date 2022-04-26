# frozen_string_literal: true

module Collections
  class Upsert
    include Dry::Effects::Handler.Resolve
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    include Dry::Monads::Do.for(:scope_for)
    include Dry::Effects.Resolve(:default_collection_schema)
    include WDPAPI::Deps[
      apply_properties: "schemas.instances.apply",
      calculate_edge: "schemas.edges.calculate"
    ]
    include MonadicPersistence

    # @param [String] identifier
    # @param [String] title
    # @param [Collection, Community] parent
    def call(identifier, title:, parent:, properties: {})
      scope = yield scope_for parent

      collection = scope.by_identifier(identifier).first_or_initialize

      collection.title = title

      collection.schema_version = collection_schema

      yield monadic_save collection

      yield apply_properties.call(collection, properties) if properties.present?

      Success collection
    end

    # @param [SchemaVersion]
    def with_schema(schema_version)
      provide default_collection_schema: schema_version do
        yield
      end
    end

    private

    def collection_schema
      default_collection_schema { SchemaVersion["default:collection"] }
    end

    # @return [ActiveRecord::Relation<Collection>]
    def scope_for(parent)
      edge = yield calculate_edge.(parent, :collection)

      Success parent.public_send edge.associations.child
    end
  end
end
