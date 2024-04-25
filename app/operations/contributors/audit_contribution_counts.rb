# frozen_string_literal: true

module Contributors
  # Occasionally a {Contributor}'s counts can get out of sync. This operation
  # audits the database and performs a minimal update as necessary.
  class AuditContributionCounts
    include Dry::Monads[:result]
    include QueryOperation

    # The start of the query to get the counts
    PREFIX = <<~SQL
    WITH uc AS (
      SELECT c.id AS contributor_id,
        ic.contribution_count AS item_contribution_count,
        cc.contribution_count AS collection_contribution_count
      FROM contributors c
      LEFT JOIN LATERAL (
        SELECT COUNT(*) AS contribution_count FROM item_contributions WHERE contributor_id = c.id
      ) ic ON true
      LEFT JOIN LATERAL (
        SELECT COUNT(*) AS contribution_count FROM collection_contributions WHERE contributor_id = c.id
      ) cc ON true
      WHERE c.item_contribution_count <> ic.contribution_count OR c.collection_contribution_count <> cc.contribution_count
    SQL

    INFIX = <<~SQL
    )
    UPDATE contributors AS c SET collection_contribution_count = uc.collection_contribution_count, item_contribution_count = uc.item_contribution_count
    FROM uc
    WHERE uc.contributor_id = c.id
    SQL

    # @param [String, <String>] contributor_id an optional contributor id to scope the update by
    # @return [Dry::Monads::Result]
    def call(contributor_id: nil)
      conditions = generate_conditions_for(contributor_id:)

      updated = sql_update! PREFIX, conditions, INFIX, conditions

      Success updated
    end

    private

    # @param [String, <String>] contributor_id an optional contributor id to scope the update by
    # @return [String]
    def generate_conditions_for(contributor_id:)
      contributor_conditions = with_quoted_id_or_ids_on(:c, contributor_id)

      compile_and contributor_conditions, prefix: true
    end
  end
end
