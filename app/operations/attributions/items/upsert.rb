# frozen_string_literal: true

module Attributions
  module Items
    # @api private
    # @see Attribution
    # @see Item
    # @see ItemAttribution
    # @see ItemContribution
    # @see Contribution
    class Upsert
      include Dry::Monads[:result]

      include QueryOperation

      PREFIX = <<~SQL
      WITH attributed AS (
        SELECT DISTINCT ON (cont.item_id, cont.contributor_id)
          cont.item_id,
          cont.contributor_id,
          dense_rank() OVER w AS position
        FROM item_contributions cont
        INNER JOIN controlled_vocabulary_items cvi ON cvi.id = cont.role_id
        INNER JOIN contributors cbtr ON cbtr.id = cont.contributor_id
      SQL

      SUFFIX = <<~SQL
        WINDOW w AS (
          PARTITION BY cont.item_id
          ORDER BY cont.outer_position ASC NULLS LAST, cvi.priority DESC NULLS LAST, cvi.position ASC, cvi.identifier ASC, cont.inner_position ASC NULLS LAST, cbtr.sort_name ASC
        )
      )
      INSERT INTO item_attributions (item_id, contributor_id, position, created_at, updated_at)
      SELECT item_id, contributor_id, position, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM attributed
      ON CONFLICT (item_id, contributor_id) DO UPDATE SET
        position = EXCLUDED.position,
        updated_at =
          CASE
          WHEN item_attributions.position IS DISTINCT FROM EXCLUDED.position
          THEN excluded.updated_at
          ELSE item_attributions.updated_at
          END
      SQL

      # @param [Item, nil] item
      # @return [Dry::Monads::Success(Integer)]
      def call(item: nil)
        cond = with_quoted_id_for(item, <<~SQL)
        WHERE cont.item_id = %1$s
        SQL

        query = compile_query PREFIX, cond, SUFFIX

        result = sql_update! query

        Success result
      end
    end
  end
end
