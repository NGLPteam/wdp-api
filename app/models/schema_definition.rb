# frozen_string_literal: true

class SchemaDefinition < ApplicationRecord
  include HasCalculatedSystemSlug

  BUILTIN_NAMESPACES = %w[default nglp testing].freeze

  PARAMETER_FORMAT = /\A[a-z][a-z0-9_]+[a-z0-9]\z/.freeze

  pg_enum! :kind, as: "schema_kind"

  has_many :schema_versions, dependent: :destroy, inverse_of: :schema_definition

  scope :by_namespace, ->(namespace) { where(namespace: namespace) }
  scope :by_identifier, ->(identifier) { where(identifier: identifier) }
  scope :by_tuple, ->(namespace, identifier) { by_namespace(namespace).by_identifier(identifier) }

  scope :builtin, -> { by_namespace(BUILTIN_NAMESPACES) }
  scope :custom, -> { where.not(namespace: BUILTIN_NAMESPACES) }
  scope :non_default, -> { where.not(namespace: %w[default testing]) }

  validates :name, :identifier, :kind, :namespace, presence: true

  validates :identifier, :namespace, format: { with: PARAMETER_FORMAT }

  validates :identifier, uniqueness: { scope: :namespace }

  before_validation :enforce_namespace_identifier_format!

  def builtin?
    namespace.in? BUILTIN_NAMESPACES
  end

  def custom?
    namespace? && !builtin?
  end

  def calculate_system_slug
    "#{namespace}:#{identifier}" if namespace? && identifier?
  end

  # @return [void]
  def reorder_versions!
    call_operation("schemas.versions.reorder", self)
  end

  def to_declaration
    slice(:namespace, :identifier)
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
      WDPAPI::Container["schemas.definitions.find"].call(needle).value_or do |(_, message)|
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

    # @param [String] namespace
    # @param [String] identifier
    # @return [SchemaDefinition]
    def lookup_or_initialize(namespace, identifier)
      where(namespace: namespace, identifier: identifier).first_or_initialize
    end
  end
end
