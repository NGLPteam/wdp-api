# frozen_string_literal: true

module Entities
  # Calculate which {LayoutDefinition}s should apply to a specific {HierarchicalEntity},
  # based on {LayoutDefinitionHierarchy}.
  #
  # This is used for a number of tasks.
  #
  # @see Entities::DeriveLayoutDefinitions
  class LayoutDefinitionsDeriver < Support::HookBased::Actor
    include QueryOperation
    include Dry::Initializer[undefined: false].define -> do
      option :entity, Entities::Types::Entity.optional, optional: true
    end

    PREFIX = <<~SQL.strip_heredoc
    WITH derivations AS NOT MATERIALIZED (
      SELECT DISTINCT ON (ent.entity_id, ldh.layout_kind)
        ent.schema_version_id,
        ent.entity_type,
        ent.entity_id,
        ldh.layout_definition_type,
        ldh.layout_definition_id,
        ldh.kind AS layout_definition_kind,
        ldh.layout_kind
        FROM entities ent
        INNER JOIN layout_definition_hierarchies ldh USING (schema_version_id)
        WHERE ent.auth_path <@ ldh.auth_path AND ent.real
    SQL

    SUFFIX = <<~SQL.strip_heredoc
        ORDER BY ent.entity_id, ldh.layout_kind, ldh.depth DESC
    )
    INSERT INTO entity_derived_layout_definitions (schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, layout_kind)
    SELECT schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, layout_kind FROM derivations d
    ON CONFLICT (entity_id, layout_kind) DO UPDATE SET
      schema_version_id = EXCLUDED.schema_version_id,
      entity_type = EXCLUDED.entity_type,
      layout_definition_type = EXCLUDED.layout_definition_type,
      layout_definition_id = EXCLUDED.layout_definition_id,
      updated_at = CURRENT_TIMESTAMP
    SQL

    standard_execution!

    # @return [String, nil]
    attr_reader :entity_constraint

    # @return [Integer]
    attr_reader :derived

    # @return [Dry::Monads::Result]
    def call
      run_callbacks :execute do
        yield prepare!

        yield derive!
      end

      Success derived
    end

    wrapped_hook! def prepare
      @derived = 0

      @entity_constraint = with_quoted_id_for(entity, <<~SQL)
      AND ent.entity_id = %1$s
      SQL
      super
    end

    wrapped_hook! def derive
      @derived = sql_update!(PREFIX, entity_constraint, SUFFIX)

      super
    end
  end
end
