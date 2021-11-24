# frozen_string_literal: true

# This is a view used to connect an {Entity} with its ancestors in the tree,
# optimized so that an {Item} can easily retrieve its ancestral {Collection}s
# and {Community}.
class EntityBreadcrumb < ApplicationRecord
  include View

  self.primary_key = %i[entity_id crumb_id]

  belongs_to :entity, polymorphic: true, inverse_of: :entity_breadcrumbs

  belongs_to :crumb, polymorphic: true, inverse_of: :entity_breadcrumb_entries

  belongs_to :schema_version
  has_one :schema_definition, through: :schema_version

  scope :filtered_by_schema_version, ->(schemas) { where(schema_version: SchemaVersion.filtered_by(schemas)) }
end
