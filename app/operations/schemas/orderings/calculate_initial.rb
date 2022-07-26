# frozen_string_literal: true

module Schemas
  module Orderings
    # Calculate the {InitialOrderingLink} for a specific {HierarchicalEntity entity},
    # or all entities at once if none is provided.
    class CalculateInitial
      include Dry::Monads[:do, :result]
      include QueryOperation

      # Select from {InitialOrderingSelection} and {InitialOrderingDerivation} and pick
      # the appropriate ordering to link to the associated entity.
      PREFIX = <<~SQL.squish.strip_heredoc.squish.freeze
      INSERT INTO initial_ordering_links (entity_type, entity_id, ordering_id, kind)
      SELECT entity_type, entity_id, COALESCE(selected.ordering_id, derived.ordering_id) AS ordering_id,
        CASE WHEN selected.ordering_id IS NOT NULL THEN 'selected'::initial_ordering_kind ELSE 'derived'::initial_ordering_kind END AS kind
      FROM initial_ordering_selections AS selected
      FULL OUTER JOIN initial_ordering_derivations AS derived USING (entity_type, entity_id)
      WHERE
        entity_type IS NOT NULL
        AND
        entity_id IS NOT NULL
        AND
        (selected.ordering_id IS NOT NULL OR derived.ordering_id IS NOT NULL)
      SQL

      SUFFIX = <<~SQL.squish.strip_heredoc.squish.freeze
      ON CONFLICT (entity_type, entity_id) DO UPDATE SET
        ordering_id = EXCLUDED.ordering_id,
        updated_at = CASE initial_ordering_links.ordering_id WHEN EXCLUDED.ordering_id THEN initial_ordering_links.updated_at ELSE CURRENT_TIMESTAMP END
      ;
      SQL

      # @param [HierarchicalEntity, nil] entity
      # @return [Dry::Monads::Success]
      def call(entity: nil)
        inserted = sql_insert! PREFIX, generate_infix_for(entity: entity), SUFFIX

        # If all orderings for an entity are disabled, the above query won't remove them.
        # We'll do that here:
        InitialOrderingLink.to_purge.delete_all

        Success inserted
      end

      private

      # Generate an infix to possibly fit between {PREFIX} and {SUFFIX}.
      #
      # @param [HierarchicalEntity, nil] entity
      # @return [String]
      def generate_infix_for(entity: nil)
        case entity
        when HierarchicalEntity
          with_sql_template(<<~SQL.squish, type: connection.quote(entity.entity_type), id: connection.quote(entity.id))
          AND entity_type = %<type>s AND entity_id = %<id>s
          SQL
        else
          ""
        end
      end
    end
  end
end
