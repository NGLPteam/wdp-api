# frozen_string_literal: true

module Entities
  # Prune the {EntityHierarchy} table in case a lifecycle method neglects to delete it.
  class AuditHierarchies
    include Dry::Monads[:result]
    include QueryOperation

    # Check polymorphic associations for removed entities.
    CLEANUP = <<~SQL
    DELETE
    FROM entity_hierarchies
    WHERE
      CASE ancestor_type
      WHEN 'Community' THEN ancestor_id NOT IN (SELECT id FROM communities)
      WHEN 'Collection' THEN ancestor_id NOT IN (SELECT ID FROM collections)
      WHEN 'Item' THEN ancestor_id NOT IN (SELECT id FROM items)
      ELSE
        FALSE
      END
      OR
      CASE descendant_type
      WHEN 'Community' THEN descendant_id NOT IN (SELECT id FROM communities)
      WHEN 'Collection' THEN descendant_id NOT IN (SELECT id FROM collections)
      WHEN 'EntityLink' THEN descendant_id NOT IN (SELECT id FROM entity_links)
      WHEN 'Item' THEN descendant_id NOT IN (SELECT id FROM items)
      ELSE
        FALSE
      END
      OR
      CASE hierarchical_type
      WHEN 'Community' THEN hierarchical_id NOT IN (SELECT id FROM communities)
      WHEN 'Collection' THEN hierarchical_id NOT IN (SELECT id FROM collections)
      WHEN 'Item' THEN hierarchical_id NOT IN (SELECT id FROM items)
      ELSE
        FALSE
      END
    ;
    SQL

    # @return [Dry::Monads::Success(Integer)]
    def call
      Success sql_delete! CLEANUP
    end
  end
end
