# frozen_string_literal: true

# Similar to {Entity}, this is designed to describe an entity hierarchy.
#
# It works similar to the closure tree `*_hierarchies` tables, but with
# added metadata to support our polymorphic tree.
class EntityHierarchy < ApplicationRecord
  self.primary_key = %i[ancestor_id descendant_id]

  belongs_to_readonly :ancestor, polymorphic: true
  belongs_to_readonly :descendant, polymorphic: true
  belongs_to_readonly :schema_definition
  belongs_to_readonly :schema_version
end
