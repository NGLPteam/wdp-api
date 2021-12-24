# frozen_string_literal: true

# Stores a parsed, database-sortable value for a {HasSchemaDefinition Schema Instance}.
#
# @see Schemas::Instances::ExtractOrderableProperties
class EntityOrderableProperty < ApplicationRecord
  include FiltersBySchemaDefinition

  self.inheritance_column = :_type_disabled

  pg_enum! :type, as: "schema_property_type", _prefix: :with, _suffix: :type

  belongs_to :entity, polymorphic: true, inverse_of: :entity_orderable_properties
  belongs_to :schema_version_property, inverse_of: :entity_orderable_properties

  has_one :schema_version, through: :schema_version_property
  has_one :schema_definition, through: :schema_version_property

  scope :by_path, ->(path) { where(path: path) }

  validates :path, presence: true, uniqueness: { scope: %i[entity_id entity_type] }

  class << self
    def coerced_value?(column_name)
      /(?<!raw)_value\z/.match?(column_name) && column_name.to_s.in?(column_names)
    end

    def value_column_for_type(type)
      return :raw_value if type.blank?

      value_column = :"#{type}_value"

      coerced_value?(value_column) ? value_column : :raw_value
    end
  end
end
