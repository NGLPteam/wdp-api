# frozen_string_literal: true

module Entities
  # Populate and maintain the {EntityHierarchy} table from descendants.
  #
  # This happens automatically when {Entities::Sync} is called.
  # @see Entities::SyncHierarchies
  class HierarchyPopulator
    include Dry::Initializer[undefined: false].define -> do
      param :descendant, Entities::Types::Syncable
      param :ancestors, Entities::Types::Syncables
    end

    include Dry::Monads[:do, :result]

    delegate :auth_path, to: :descendant

    def call
      yield preload!

      yield upsert!

      yield prune!

      Success()
    end

    private

    # @return [Dry::Monads::Result]
    def preload!
      ::ActiveRecord::Associations::Preloader.new(records: ancestors, associations: %i[schema_version schema_definition]).call

      Success()
    end

    # @return [Dry::Monads::Result]
    def upsert!
      EntityHierarchy.upsert_all upsertable_rows, unique_by: %i[ancestor_id descendant_id]

      Success()
    end

    # @return [Dry::Monads::Result]
    def prune!
      EntityHierarchy.where(descendant:).where.not(ancestor: ancestors).delete_all

      Success()
    end

    def upsertable_rows
      shared = {
        descendant_type: descendant.entity_type,
        descendant_id: descendant.id_for_entity,
        hierarchical_type: descendant.hierarchical_type,
        hierarchical_id: descendant.hierarchical_id,
        link_operator: link_operator_for(descendant),
        auth_path:,
        schema_definition_id: descendant.schema_definition.id,
        schema_version_id: descendant.schema_version.id,
        title: title_for(descendant),
        descendant_scope: descendant.entity_scope,
        descendant_slug:,
        created_at: descendant.created_at,
        updated_at: descendant.updated_at,
      }

      ancestors.map do |ancestor|
        {
          ancestor_type: ancestor.entity_type,
          ancestor_id: ancestor.id_for_entity,
          ancestor_slug: target_slug_for(ancestor),
          ancestor_scope: ancestor.entity_scope,
        }.merge(shared)
      end
    end

    def descendant_slug
      target_slug_for descendant
    end

    def link_operator_for(value)
      case value
      when EntityLink
        value.operator
      end
    end

    def title_for(value)
      case value
      when EntityLink
        value.target.title
      else
        value.title
      end
    end

    def target_slug_for(value)
      case value
      when EntityLink
        value.target.system_slug
      else
        value.system_slug
      end
    end
  end
end
