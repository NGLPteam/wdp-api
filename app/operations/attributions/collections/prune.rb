# frozen_string_literal: true

module Attributions
  module Collections
    # @api private
    # @see Attribution
    # @see Collection
    # @see CollectionAttribution
    # @see CollectionContribution
    # @see Contribution
    class Prune
      include Dry::Monads[:result]

      include QueryOperation

      PREFIX = <<~SQL
      DELETE FROM collection_attributions AS at
      WHERE at.id IN (
        SELECT at.id FROM collection_attributions at
        LEFT OUTER JOIN collection_contributions cont USING (collection_id, contributor_id)
        WHERE cont.id IS NULL
      SQL

      SUFFIX = <<~SQL
      )
      SQL

      # @param [Collection, nil] collection
      # @return [Dry::Monads::Success(Integer)]
      def call(collection: nil)
        id_eq = with_quoted_id_for(collection, <<~SQL)
        at.collection_id = %1$s
        SQL

        cond = compile_and(id_eq, prefix: true)

        query = compile_query PREFIX, cond, SUFFIX, cond

        result = sql_delete! query

        Success result
      end
    end
  end
end
