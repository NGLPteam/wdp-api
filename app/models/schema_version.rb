# frozen_string_literal: true

class SchemaVersion < ApplicationRecord
  include HasCalculatedSystemSlug

  attr_readonly :parsed

  belongs_to :schema_definition, inverse_of: :schema_versions

  has_many :communities, dependent: :restrict_with_error, inverse_of: :schema_version
  has_many :collections, dependent: :restrict_with_error, inverse_of: :schema_version
  has_many :items, dependent: :restrict_with_error, inverse_of: :schema_version

  has_many :entity_links, dependent: :destroy

  attribute :number, :semantic_version
  attribute :configuration, Schemas::Versions::Configuration.to_type, default: {}

  scope :by_namespace, ->(namespace) { joins(:schema_definition).merge(SchemaDefinition.by_namespace(namespace)) }
  scope :by_identifier, ->(identifier) { joins(:schema_definition).merge(SchemaDefinition.by_identifier(identifier)) }
  scope :by_tuple, ->(namespace, identifier) { joins(:schema_definition).merge(SchemaDefinition.by_tuple(namespace, identifier)) }

  scope :by_number, ->(number) { where(number: number) }
  scope :by_schema_definition, ->(schema_definition) { where(schema_definition: schema_definition) if schema_definition.present? }
  scope :by_kind, ->(kind) { joins(:schema_definition).merge(SchemaDefinition.by_kind(kind)) }

  scope :current, -> { where(current: true) }

  scope :in_default_order, -> { joins(:schema_definition).merge(SchemaDefinition.in_default_order).order(parsed: :desc) }

  delegate :collection?, :community?, :item?, :kind,
    :identifier, :namespace, :name,
    to: :schema_definition

  delegate :has_ordering?, :ordering_definition_for, :property_for, :property_paths, to: :configuration, allow_nil: true

  before_validation :extract_reference_paths!

  validates :number, presence: true, uniqueness: { scope: :schema_definition }

  # @!attribute [r] label
  # @return [String]
  def label
    "#{name} v#{number}"
  end

  def to_declaration
    slice(:id).merge(version: number.to_s).merge(schema_definition.to_declaration)
  end

  def calculate_system_slug
    schema_definition&.calculate_system_slug.then do |prefix|
      "#{prefix}:#{number}" if prefix.present?
    end
  end

  # @see Schemas::Versions::ReadProperties
  # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
  def read_properties
    call_operation("schemas.versions.read_properties", self)
  end

  def to_validation_contract
    call_operation("schemas.properties.compile_contract", self).value!
  end

  # @return [void]
  def reload_static_version!
    raw_configuration = static_definition&.raw_data

    return if raw_configuration.blank?

    self.configuration = raw_configuration

    configuration_will_change!

    save!
  end

  def static_definition
    ::Schemas::Static["definitions.map"][static_definition_key][number.to_s]
  rescue Dry::Container::Error
    return nil
  end

  def static_definition_key
    "#{namespace}.#{identifier}"
  end

  # @api private
  # @return [void]
  def extract_reference_paths!
    self.collected_reference_paths = Array(configuration&.collected_reference_paths)
    self.scalar_reference_paths = Array(configuration&.scalar_reference_paths)
    self.text_reference_paths = Array(configuration&.text_reference_paths)
  end

  class << self
    # @param [String] needle
    # @return [SchemaVersion]
    def [](needle)
      WDPAPI::Container["schemas.versions.find"].call(needle).value_or do |(_, message)|
        raise ActiveRecord::RecordNotFound, message
      end
    end

    # @raise [ActiveRecord::RecordNotFound] if no current version set
    # @return [SchemaVersion]
    def default_collection
      by_tuple("default", "collection").latest!
    end

    # @raise [ActiveRecord::RecordNotFound] if no current version set
    # @return [SchemaVersion]
    def default_community
      by_tuple("default", "community").latest!
    end

    # @raise [ActiveRecord::RecordNotFound] if no current version set
    # @return [SchemaVersion]
    def default_item
      by_tuple("default", "item").latest!
    end

    def filtered_by(schemas)
      schema_versions = Array(schemas).map do |needle|
        WDPAPI::Container["schemas.versions.find"].call(needle).value_or(nil)
      end.compact

      if schema_versions.present?
        where(id: schema_versions)
      elsif schemas.present?
        none
      else
        all
      end
    end

    # @raise [ActiveRecord::RecordNotFound] if no current version set
    def latest!
      current.first!
    end

    # @param [:latest, String] number
    # @raise [ActiveRecord::RecordNotFound] if current version set or no number found
    # @return [SchemaVersion]
    def lookup(number)
      number == :latest ? latest! : by_number(number).only_one!
    end

    # @param [String] number
    # @return [SchemaVersion]
    def lookup_or_initialize(number, schema_definition: nil)
      by_schema_definition(schema_definition).by_number(number).only_one_or_initialize
    end
  end
end
