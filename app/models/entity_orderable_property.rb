# frozen_string_literal: true

# Stores a parsed, database-sortable value for a {HasSchemaDefinition Schema Instance}.
#
# @see Schemas::Instances::ExtractOrderableProperties
class EntityOrderableProperty < ApplicationRecord
  include FiltersBySchemaDefinition

  # @api private
  SUPPORTED_PROPERTY_TYPES = %i[
    boolean
    date
    email
    float
    integer
    string
    timestamp
    variable_date
  ].freeze

  self.inheritance_column = :_type_disabled

  pg_enum! :type, as: "schema_property_type", _prefix: :with, _suffix: :type

  belongs_to :entity, polymorphic: true, inverse_of: :entity_orderable_properties
  belongs_to :schema_version_property, inverse_of: :entity_orderable_properties

  has_one :schema_version, through: :schema_version_property
  has_one :schema_definition, through: :schema_version_property

  scope :by_path, ->(path) { where(path: path) }
  scope :filtered_by_schema_version, ->(*args) { joins(:schema_version_property).merge(SchemaVersionProperty.filtered_by_schema_version(*args)) }

  validates :path, presence: true, uniqueness: { scope: %i[entity_id entity_type] }

  class << self
    # Check if the provided column is one of the generated coerced columns for
    # this model.
    #
    # @see .value_column_for_type
    # @param [#to_s] column_name
    def coerced_value?(column_name)
      /(?<!raw)_value\z/.match?(column_name) && column_name.to_s.in?(column_names)
    end

    # Return the generated, properly typed SQL column for the specified value.
    #
    # @param [#to_s] type
    # @return [Symbol]
    def value_column_for_type(type)
      return :raw_value if type.blank?

      value_column = :"#{type}_value"

      coerced_value?(value_column) ? value_column : :raw_value
    end
  end
end
