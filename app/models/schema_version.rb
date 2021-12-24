# frozen_string_literal: true

class SchemaVersion < ApplicationRecord
  pg_enum! :kind, as: "schema_kind"

  attr_readonly :declaration, :identifier, :name, :namespace, :number, :parsed, :schema_definition_id

  belongs_to :schema_definition, inverse_of: :schema_versions

  has_many :communities, dependent: :restrict_with_error, inverse_of: :schema_version
  has_many :collections, dependent: :restrict_with_error, inverse_of: :schema_version
  has_many :items, dependent: :restrict_with_error, inverse_of: :schema_version

  has_many :schema_version_ancestors, dependent: :delete_all, inverse_of: :schema_version
  has_many :schema_version_descendants, dependent: :delete_all, inverse_of: :target_version, class_name: "SchemaVersionAncestor"
  has_many :schema_version_properties, dependent: :delete_all, inverse_of: :schema_version

  has_many :entity_links, dependent: :destroy

  attribute :number, :semantic_version
  attribute :configuration, Schemas::Versions::Configuration.to_type, default: {}

  scope :by_namespace, ->(namespace) { where(namespace: namespace) }
  scope :by_identifier, ->(identifier) { where(identifier: identifier) }
  scope :by_tuple, ->(namespace, identifier) { by_namespace(namespace).by_identifier(identifier) }

  scope :by_number, ->(number) { where(number: number) }
  scope :by_schema_definition, ->(schema_definition) { where(schema_definition: schema_definition) if schema_definition.present? }
  scope :by_kind, ->(kind) { joins(:schema_definition).merge(SchemaDefinition.by_kind(kind)) }

  scope :current, -> { where(current: true) }

  scope :in_default_order, -> { joins(:schema_definition).merge(SchemaDefinition.in_default_order).order(parsed: :desc) }
  scope :by_position, -> { order(position: :desc) }

  delegate :has_ordering?, :ordering_definition_for, :property_for, :property_paths, to: :configuration, allow_nil: true
  delegate :identifier, :namespace, :version, to: :configuration, allow_nil: true, prefix: :configured

  before_validation :extract_reference_paths!

  after_create :reorder_versions!

  after_update :maybe_reorder_versions!

  after_save :extract_ancestors!

  after_save :extract_properties!

  validates :configuration, store_model: true

  validate :configuration_matches_definition!

  alias_attribute :system_slug, :declaration

  # @!attribute [r] gem_version
  # @note Used for comparison with Gem::Requirements
  # @see Schemas::Associations::SatisfiedBy
  # @return [Gem::Version]
  def gem_version
    Gem::Version.new(number)
  end

  # @!attribute [r] label
  # A human-readable label for this particular schema version.
  # @return [String]
  def label
    "#{name} v#{number}"
  end

  # Transform the schema's properties into an array of readers that
  # can be consumed by the GraphQL API in order to iterate over them
  # in deterministic order.
  #
  # @see Schemas::Versions::ReadProperties
  # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
  def read_properties
    call_operation("schemas.versions.read_properties", self)
  end

  # Generate a hash of values that gets set in an Entity's `properties.schema`
  # in order to "sign" the property hash as belonging to a certain schema version.
  #
  # @return [Hash]
  def to_declaration
    slice(:id, :identifier, :namespace).merge(version: number.to_s)
  end

  # Compute a validation contract for this schema.
  #
  # @see Schemas::Properties::CompileContract
  # @return [ApplicationContract]
  def to_validation_contract
    call_operation("schemas.properties.compile_contract", self).value!
  end

  # Calculate an array of attributes that will be turned
  # into associated {SchemaVersionProperty} records.
  #
  # @api private
  # @see Schemas::Versions::ExtractProperties
  # @see Schemas::Versions::Configuration#to_version_properties
  # @return [<Hash>]
  def to_version_properties
    shared_attributes = slice(:schema_definition_id).merge(schema_version_id: id)

    configuration.to_version_properties.map do |attributes|
      attributes.merge(shared_attributes)
    end
  end

  # @!group Hooks

  # @api private
  # @return [void]
  def configuration_matches_definition!
    %i[namespace identifier kind].each do |trait|
      expected = schema_definition.public_send trait
      actual = configuration.public_send trait

      next if expected == actual

      errors.add :configuration, :mismatched_trait, trait: trait, expected: expected, actual: actual
    end
  end

  # @api private
  # @return [void]
  def extract_ancestors!
    call_operation("schemas.versions.extract_ancestors", self).value!
  end

  # @api private
  # @return [void]
  def extract_properties!
    call_operation("schemas.versions.extract_properties", self).value!
  end

  # @api private
  # @return [void]
  def extract_reference_paths!
    self.collected_reference_paths = Array(configuration&.collected_reference_paths)
    self.scalar_reference_paths = Array(configuration&.scalar_reference_paths)
    self.text_reference_paths = Array(configuration&.text_reference_paths)
  end

  # @return [void]
  def maybe_reorder_versions!
    return unless should_reorder_versions?

    reorder_previous_definition_versions! if should_reorder_previous_definition_versions?

    reorder_versions!
  end

  # @api private
  # @see Schemas::Versions::Reorder
  # @return [void]
  def reorder_versions!
    call_operation("schemas.versions.reorder", schema_definition).value!
  end

  # @!endgroup

  # @!group Static Definition Methods

  # @api private
  # Reload the {#static_definition} for this schema if applicable.
  #
  # @note Intended for debugging and quick testing. To properly reload static schemas,
  #   see Schemas::Static::LoadDefinitions
  # @return [void]
  def reload_static_version!
    raw_configuration = static_definition&.raw_data

    return if raw_configuration.blank?

    self.configuration = raw_configuration

    configuration_will_change!

    save!
  end

  # @api private
  # @!attribute [r] static_definition
  # @see #static_definition_key
  # @return [Schemas::Static::Definitions::Version, nil]
  def static_definition
    ::Schemas::Static["definitions.map"][static_definition_key][number.to_s]
  rescue Dry::Container::Error
    return nil
  end

  # @api private
  # @!attribute [r] static_definition_key
  # The key used to look up a static definition for this schema version.
  # @return [String]
  def static_definition_key
    "#{namespace}.#{identifier}"
  end

  # @!endgroup

  private

  def should_reorder_versions?
    saved_change_to_schema_definition_id? || saved_change_to_number?
  end

  def should_reorder_previous_definition_versions?
    schema_definition_id_before_last_save.present? && schema_definition_id != schema_definition_id_before_last_save
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
