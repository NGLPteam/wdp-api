# frozen_string_literal: true

module Attributions
  module Items
    # @api private
    # @see Attribution
    # @see Item
    # @see ItemAttribution
    # @see ItemContribution
    # @see Contribution
    class Prune
      include Dry::Monads[:result]

      include QueryOperation

      PREFIX = <<~SQL
      DELETE FROM item_attributions AS at
      WHERE at.id IN (
        SELECT at.id FROM item_attributions at
        LEFT OUTER JOIN item_contributions cont USING (item_id, contributor_id)
        WHERE cont.id IS NULL
      SQL

      SUFFIX = <<~SQL
      )
      SQL

      # @param [Item, nil] item
      # @return [Dry::Monads::Success(Integer)]
      def call(item: nil)
        id_eq = with_quoted_id_for(item, <<~SQL)
        at.item_id = %1$s
        SQL

        cond = compile_and(id_eq, prefix: true)

        query = compile_query PREFIX, cond, SUFFIX, cond

        result = sql_delete! query

        Success result
      end
    end
  end
end
