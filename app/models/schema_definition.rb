# frozen_string_literal: true

# A logical grouping of {SchemaVersion schema versions}, unique by
# {#namespace} and {#identifier}.
#
# @subsystem Schema
class SchemaDefinition < ApplicationRecord
  include Schemas::Static::Namespaced
  include TimestampScopes

  # @!attribute [r] declaration
  # The combination of {#namespace} and {#identifier}.
  # @return [String]
  attr_readonly :declaration

  # @!attribute [r] kind
  # @return ["community", "collection", "item"]
  pg_enum! :kind, as: "schema_kind"

  has_many :schema_versions, dependent: :destroy, inverse_of: :schema_definition

  has_many :schema_version_properties, dependent: :delete_all, inverse_of: :schema_definition

  has_many :handling_orderings, class_name: "Ordering", inverse_of: :handled_schema_definition,
    foreign_key: :handled_schema_definition_id, dependent: :restrict_with_error

  has_many :entity_hierarchies, dependent: :delete_all, inverse_of: :schema_definition

  scope :by_kind, ->(kind) { where(kind:) }

  scope :in_default_order, -> { order(namespace: :asc, name: :asc) }

  validates :name, :identifier, :kind, :namespace, presence: true

  validates :identifier, :namespace, schema_component: true

  validates :identifier, uniqueness: { scope: :namespace }

  before_validation :enforce_namespace_identifier_format!

  alias_attribute :system_slug, :declaration

  # Find or initialize a {SchemaVersion} for the provided `number`.
  #
  # @param [String] number
  # @return [SchemaVersion]
  def lookup(number)
    schema_versions.where(number:).first_or_initialize
  end

  # @return [void]
  def reorder_versions!
    call_operation("schemas.versions.reorder", self)
  end

  private

  # @return [void]
  def enforce_namespace_identifier_format!
    self.namespace = namespace.parameterize.underscore if namespace?
    self.identifier = identifier.parameterize.underscore if identifier?
  end

  class << self
    # @param [String] needle
    # @return [SchemaDefinition]
    def [](needle)
      MeruAPI::Container["schemas.definitions.find"].call(needle).value_or do |(_, message)|
        raise ActiveRecord::RecordNotFound, message
      end
    end

    # @return [SchemaDefinition]
    def default_collection
      by_tuple("default", "collection").first!
    end

    # @return [SchemaDefinition]
    def default_community
      by_tuple("default", "community").first!
    end

    # @return [SchemaDefinition]
    def default_item
      by_tuple("default", "item").first!
    end

    def filtered_by(schemas)
      schema_definitions = Array(schemas).map do |needle|
        MeruAPI::Container["schemas.definitions.find"].call(needle).value_or(nil)
      end.compact

      if schema_definitions.present?
        where(id: schema_definitions)
      elsif schemas.present?
        none
      else
        all
      end
    end

    # @param [String] namespace
    # @param [String] identifier
    # @return [SchemaDefinition]
    def lookup_or_initialize(namespace, identifier)
      where(namespace:, identifier:).first_or_initialize
    end
  end
end
