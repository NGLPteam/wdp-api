# frozen_string_literal: true

module Contributors
  class CountItems
    include Dry::Monads[:result, :do]
    include QueryOperation

    def call(contributor)
      update_count = sql_update! with_quoted_id_for contributor, <<~SQL
      WITH contribution_counts AS (
        SELECT COUNT(*) AS contribution_count
        FROM item_contributions
        WHERE contributor_id = %1$s
      )
      UPDATE contributors AS c SET item_contribution_count = cc.contribution_count
      FROM contribution_counts cc
      WHERE c.id = %1$s
      SQL

      Success update_count
    end
  end
end
