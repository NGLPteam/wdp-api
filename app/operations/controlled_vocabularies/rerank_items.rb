# frozen_string_literal: true

module ControlledVocabularies
  # Calculate the `ranking` value on {ControlledVocabularyItem},
  # optionally scoped by {ControlledVocabulary}.
  #
  # @see ControlledVocabulary#rerank_item
  class RerankItems
    include Dry::Monads[:result]
    include QueryOperation

    PREFIX = <<~SQL
    WITH rankings AS (
      SELECT
        id,
        dense_rank() OVER w AS ranking
        FROM controlled_vocabulary_items
    SQL

    SUFFIX = <<~SQL
        WINDOW w AS (
          PARTITION BY controlled_vocabulary_id, parent_id
          ORDER BY priority DESC NULLS LAST, position ASC, identifier ASC
        )
    )
    UPDATE controlled_vocabulary_items SET ranking = rankings.ranking
    FROM rankings WHERE rankings.id = controlled_vocabulary_items.id;
    SQL

    # @param [ControlledVocabulary, nil] controlled_vocabulary
    # @return [Dry::Monads::Success(Integer)]
    def call(controlled_vocabulary: nil)
      conditions = compile_where(controlled_vocabulary:)

      count = sql_update!(PREFIX, conditions, SUFFIX)

      Success count
    end

    private

    # @param [ControlledVocabulary, nil] controlled_vocabulary
    # @return [String]
    def compile_where(controlled_vocabulary: nil)
      with_quoted_id_for(controlled_vocabulary, <<~SQL)
      WHERE controlled_vocabulary_id = %1$s
      SQL
    end
  end
end
