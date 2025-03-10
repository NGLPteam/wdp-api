# frozen_string_literal: true

class HarvestRecord < ApplicationRecord
  include HasHarvestErrors
  include HasHarvestSource
  include ScopesForIdentifier
  include HasHarvestMetadataFormat
  include TimestampScopes

  # :nocov:
  include Harvesting::Testing::RecordExtensions if Rails.env.test?
  # :nocov:

  pg_enum! :status, as: :harvest_record_status, allow_blank: false, prefix: :with, suffix: :status, default: "pending"

  belongs_to :harvest_source, inverse_of: :harvest_records
  belongs_to :harvest_configuration, inverse_of: :harvest_records, optional: true

  has_many :harvest_attempt_record_links, inverse_of: :harvest_record, dependent: :delete_all
  has_many :harvest_mapping_record_links, inverse_of: :harvest_record, dependent: :delete_all
  has_many :harvest_set_record_links, inverse_of: :harvest_record, dependent: :delete_all

  has_many :harvest_attempts, through: :harvest_attempt_record_links
  has_many :harvest_mappings, through: :harvest_mapping_record_links
  has_many :harvest_sets, through: :harvest_set_record_links

  has_many :harvest_entities, -> { in_default_order }, inverse_of: :harvest_record, dependent: :destroy
  has_many :harvest_contributions, through: :harvest_entities
  has_many :harvest_contributors, through: :harvest_contributions

  has_many :harvest_messages, inverse_of: :harvest_record, dependent: :destroy

  has_many_readonly :collections, through: :harvest_entities, source: :entity, source_type: "Collection"
  has_many_readonly :items, through: :harvest_entities, source: :entity, source_type: "Item"

  attribute :skipped, Harvesting::Records::Skipped.to_type, default: proc { {} }

  scope :current, -> { where(harvest_attempt: HarvestAttempt.current) }
  scope :previous, -> { where(harvest_attempt: HarvestAttempt.previous) }

  scope :filtered_by_schema_version, ->(version) { where(id: HarvestEntity.filtered_by_schema_version(version).select(:harvest_record_id)) }
  scope :active, -> { with_active_status }
  scope :skipped, -> { with_skipped_status }
  scope :upsertable, -> { active.sans_harvest_errors }
  scope :with_entities, -> { where(id: HarvestEntity.select(:harvest_record_id)) }
  scope :sans_entities, -> { where.not(id: HarvestEntity.select(:harvest_record_id)) }

  scope :sans_extracted_scalar_asset, ->(full_path) { with_entities.where.not(id: unscoped.with_extracted_scalar_asset(full_path)) }
  scope :with_extracted_scalar_asset, ->(full_path) { where(id: HarvestEntity.with_extracted_scalar_asset(full_path).select(:harvest_record_id)) }

  scope :in_default_order, -> { in_recent_order }
  scope :in_inverse_order, -> { in_oldest_order }

  # @api private
  attr_accessor :sample_record

  # @see HarvestConfiguration#build_extraction_context
  # @return [Harvesting::Extraction::Context]
  def build_extraction_context
    fetch_configuration.build_extraction_context
  end

  # @see HarvestMetadataFormat.context_for
  # @return [Harvesting::Metadata::Context]
  def build_metadata_context
    HarvestMetadataFormat.context_for(self)
  end

  # @return [Harvesting::Extraction::RenderContext]
  def build_render_context(metadata_context: build_metadata_context, extraction_context: build_extraction_context)
    Harvesting::Extraction::RenderContext.new(self, metadata_context:, extraction_context:)
  end

  # @api private
  # @return [void]
  def clear_skip!
    self.skipped = Harvesting::Records::Skipped.blank

    save!
  end

  # @see Harvesting::Records::ExtractEntities
  # @see Harvesting::Records::EntitiesExtractor
  monadic_operation! def extract_entities(...)
    call_operation("harvesting.records.extract_entities", self, ...)
  end

  def inspect
    "HarvestRecord[:#{metadata_format}](#{identifier.inspect})"
  end

  # @see Harvesting::Records::UpsertEntities
  # @return [Dry::Monads::Result]
  monadic_operation! def upsert_entities
    call_operation("harvesting.records.upsert_entities", self)
  end

  # @api private
  # @return [Hash]
  def to_sample
    changed_at = source_changed_at.iso8601

    metadata_source = Nokogiri::XML(raw_metadata_source, &:noblanks).root.to_xml

    {
      identifier:,
      changed_at:,
      metadata_source:,
    }
  end

  private

  # @raise [Harvesting::Records::NoConfiguration]
  # @return [HarvestConfiguration]
  def fetch_configuration
    # :nocov:
    raise Harvesting::Records::NoConfiguration.new(self) if harvest_configuration.blank?
    # :nocov:

    harvest_configuration
  end

  class << self
    # Return the most recent {HarvestRecord} instance from the current attempts
    # for a given `sourcelike` that is identified by `identifier`.
    #
    # @param [String, HarvestSource] sourcelike
    # @param [String] identifier
    # @return [HarvestRecord, nil]
    def fetch_for_source(sourcelike, identifier)
      for_source(sourcelike).find_by(identifier:)
    end

    # Return the most recent {HarvestRecord} instance from the current attempts
    # for a given `sourcelike` that is identified by `identifier`.
    #
    # Raise an error if one is not found.
    #
    # @param [String, HarvestSource] sourcelike
    # @param [String] identifier
    # @raise [Harvesting::Records::Unknown]
    # @return [HarvestRecord]
    def fetch_for_source!(sourcelike, identifier)
      for_source(sourcelike).find_by!(identifier:)
    rescue ActiveRecord::RecordNotFound
      raise Harvesting::Records::Unknown, identifier
    end
  end
end
