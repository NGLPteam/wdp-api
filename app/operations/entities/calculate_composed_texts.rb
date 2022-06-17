# frozen_string_literal: true

module Entities
  class CalculateComposedTexts
    include Dry::Monads[:do, :result]
    include QueryOperation

    prepend TransactionalCall

    PREFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    INSERT INTO entity_composed_texts (entity_type, entity_id, document)
    SELECT entity_type, entity_id, tsvector_agg(document) AS document
    FROM schematic_texts
    SQL

    SUFFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    GROUP BY 1, 2
    ON CONFLICT (entity_type, entity_id) DO UPDATE SET
      document = EXCLUDED.document,
      updated_at = CASE WHEN EXCLUDED.document IS DISTINCT FROM entity_composed_texts.document THEN CURRENT_TIMESTAMP ELSE entity_composed_texts.updated_at END
    ;
    SQL

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Success(Integer)]
    def call(entity: nil)
      inserted = sql_insert! PREFIX, generate_infix_for(entity: entity), SUFFIX

      Success(inserted)
    end

    private

    # Generate an infix to possibly fit between {PREFIX} and {SUFFIX}.
    #
    # @param [String] auth_path
    # @param [Boolean] stale
    # @return [String]
    def generate_infix_for(entity: nil)
      with_quoted_id_for(entity, <<~SQL)
      WHERE entity_id = %1$s
      SQL
    end
  end
end
