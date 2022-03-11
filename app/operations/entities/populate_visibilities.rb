# frozen_string_literal: true

module Entities
  # Ensure {EntityVisibility} is populated for each extant {Entity}.
  #
  # @see Entities::PopulateVisibilitiesJob
  class PopulateVisibilities
    include Dry::Monads[:result]
    include QueryOperation

    QUERY = <<~SQL
    INSERT INTO entity_visibilities (entity_type, entity_id)
    SELECT DISTINCT hierarchical_type, hierarchical_id
    FROM entities
    WHERE
      scope IN ('collections', 'items')
      AND
      (hierarchical_type, hierarchical_id) NOT IN (SELECT entity_type, entity_id FROM entity_visibilities)
    ON CONFLICT (entity_type, entity_id) DO NOTHING;
    SQL

    # @return [Dry::Monads::Success]
    def call
      sql_insert! QUERY

      Success()
    end
  end
end
