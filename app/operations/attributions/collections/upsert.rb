# frozen_string_literal: true

module Attributions
  module Collections
    # @api private
    # @see Attribution
    # @see Collection
    # @see CollectionAttribution
    # @see CollectionContribution
    # @see Contribution
    class Upsert
      include Dry::Monads[:result]

      include QueryOperation

      PREFIX = <<~SQL
      WITH attributed AS (
        SELECT DISTINCT ON (cont.collection_id, cont.contributor_id)
          cont.collection_id,
          cont.contributor_id,
          dense_rank() OVER w AS position
        FROM collection_contributions cont
        INNER JOIN controlled_vocabulary_items cvi ON cvi.id = cont.role_id
        INNER JOIN contributors cbtr ON cbtr.id = cont.contributor_id
      SQL

      SUFFIX = <<~SQL
        WINDOW w AS (
          PARTITION BY cont.collection_id
          ORDER BY cvi.priority DESC NULLS LAST, cvi.position ASC, cvi.identifier ASC, cont.position ASC NULLS LAST, cbtr.sort_name ASC
        )
      )
      INSERT INTO collection_attributions (collection_id, contributor_id, position, created_at, updated_at)
      SELECT collection_id, contributor_id, position, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM attributed
      ON CONFLICT (collection_id, contributor_id) DO UPDATE SET
        position = EXCLUDED.position,
        updated_at =
          CASE
          WHEN collection_attributions.position IS DISTINCT FROM EXCLUDED.position
          THEN excluded.updated_at
          ELSE collection_attributions.updated_at
          END
      SQL

      # @param [Collection, nil] collection
      # @return [Dry::Monads::Success(Integer)]
      def call(collection: nil)
        cond = with_quoted_id_for(collection, <<~SQL)
        WHERE cont.collection_id = %1$s
        SQL

        query = compile_query PREFIX, cond, SUFFIX

        result = sql_update! query

        Success result
      end
    end
  end
end
