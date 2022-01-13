# frozen_string_literal: true

# An interface for a model that can be filtered by {SchemaVersion}.
#
# It requires that the implementing model has a `schema_version` association
# defined directly on it, rather than through some determinant.
module FiltersBySchemaVersion
  extend ActiveSupport::Concern

  included do
    # Filter by {SchemaVersion}.
    #
    # @param (@see SchemaVersion.filtered_by)
    scope :filtered_by_schema_version, ->(schemas) { where(schema_version: SchemaVersion.filtered_by(schemas)) }
  end
end
