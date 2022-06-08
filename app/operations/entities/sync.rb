# frozen_string_literal: true

module Entities
  # Synchronizes a {SyncsEntities model} into an {Entity} representation.
  class Sync
    include Dry::Monads[:try, :do, :result]
    include WDPAPI::Deps[
      calculate_authorizing: "entities.calculate_authorizing",
      validate_sync: "entities.validate_sync",
    ]

    # The index used for upserting an {Entity}.
    UNIQUE_INDEX = %i[entity_type entity_id].freeze

    # @param [SyncsEntities] source
    def call(source)
      result = yield attributes_from source

      attributes = result.to_h

      yield upsert! attributes

      yield maybe_upsert_visibility! source

      Entities::SyncHierarchiesJob.perform_later source

      calculate_authorizing.call auth_path: source.entity_auth_path
    end

    private

    # @param [SyncsEntities] source
    # @return [Dry::Validation::Result]
    def attributes_from(source)
      tuple = source.to_entity_tuple.symbolize_keys

      tuple[:auth_path] = source.entity_auth_path
      tuple[:entity_id] = source.id_for_entity
      tuple[:entity_type] = source.entity_type
      tuple[:hierarchical_id] = source.hierarchical_id
      tuple[:hierarchical_type] = source.hierarchical_type
      tuple[:scope] = source.entity_scope
      tuple[:system_slug] = source.entity_slug

      validate_sync.call(tuple).to_monad
    end

    # @param [{ Symbol => Object }] attributes
    def upsert!(attributes)
      Try do
        Entity.upsert attributes, unique_by: UNIQUE_INDEX
      end.to_monad
    end

    def maybe_upsert_visibility!(source)
      return Success() unless source.kind_of?(ChildEntity)

      tuple = {}

      tuple[:entity_id] = source.id_for_entity
      tuple[:entity_type] = source.entity_type

      Try do
        EntityVisibility.upsert tuple, unique_by: UNIQUE_INDEX
      end.to_monad
    end
  end
end
