# frozen_string_literal: true

module Entities
  # Synchronizes a {SyncsEntities model} into an {Entity} representation.
  class Sync
    include Dry::Monads[:do, :result]
    include MonadicPersistence
    include WDPAPI::Deps[
      calculate_authorizing: "entities.calculate_authorizing",
      validate_sync: "entities.validate_sync",
    ]

    # The index used for upserting an {Entity}.
    UNIQUE_INDEX = %i[entity_type entity_id].freeze

    # @param [SyncsEntities] source
    # @return [Dry::Monads::Result]
    def call(source)
      attributes = yield attributes_from source

      yield upsert! attributes

      yield maybe_upsert_visibility! source

      Entities::SyncHierarchiesJob.perform_later source

      yield calculate_authorizing! source

      Success()
    end

    private

    # @param [SyncsEntities] source
    # @return [Dry::Monads::Success(Hash)]
    # @return [Dry::Monads::Failure(Dry::Validation::Result)]
    def attributes_from(source)
      tuple = source.to_entity_tuple.symbolize_keys

      tuple[:auth_path] = source.entity_auth_path
      tuple[:entity_id] = source.id_for_entity
      tuple[:entity_type] = source.entity_type
      tuple[:hierarchical_id] = source.hierarchical_id
      tuple[:hierarchical_type] = source.hierarchical_type
      tuple[:scope] = source.entity_scope
      tuple[:system_slug] = source.entity_slug

      validate_sync.call(tuple).to_monad.fmap(&:to_h)
    end

    # @param [{ Symbol => Object }] attributes
    # @return [Dry::Monads::Result]
    def upsert!(attributes)
      monadic_upsert Entity, attributes, unique_by: UNIQUE_INDEX, skip_find: true
    end

    # @param [SyncsEntities] source
    # @return [Dry::Monads::Result]
    def maybe_upsert_visibility!(source)
      return Success() unless source.kind_of?(ChildEntity)

      tuple = {}

      tuple[:entity_id] = source.id_for_entity
      tuple[:entity_type] = source.entity_type

      monadic_upsert EntityVisibility, tuple, unique_by: UNIQUE_INDEX, skip_find: true
    end

    # @param [SyncsEntities] source
    # @return [Dry::Monads::Result]
    def calculate_authorizing!(source)
      calculate_authorizing.call auth_path: source.entity_auth_path
    end
  end
end
