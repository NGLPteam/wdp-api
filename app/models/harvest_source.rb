# frozen_string_literal: true

class HarvestSource < ApplicationRecord
  include GloballyUniqueIdentifier
  include HarvestAttemptable
  include HarvestConfigurable
  include HasEphemeralSystemSlug
  include HasHarvestingOptions
  include HasHarvestMetadataFormat
  include TimestampScopes

  # :nocov:
  include Harvesting::Testing::SourceExtensions if Rails.env.test?
  # :nocov:

  pg_enum! :protocol, as: :harvest_protocol, allow_blank: false, default: "unknown", prefix: :with, suffix: :protocol
  pg_enum! :status, as: :harvest_source_status, allow_blank: false, default: "inactive"

  composed_of :harvest_protocol,
    class_name: "HarvestProtocol",
    mapping: [%w[protocol protocol_name]],
    constructor: ->(name) { HarvestProtocol.find(name) }

  has_many :harvest_attempts, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_configurations, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_contributors, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_messages, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_metadata_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_records, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_sets, inverse_of: :harvest_source, dependent: :destroy

  has_many_readonly :latest_harvest_attempt_links, inverse_of: :harvest_source

  has_many_readonly :latest_harvest_attempts, through: :latest_harvest_attempt_links,
    source: :harvest_attempt

  scope :in_default_order, -> { lazily_order(:name, :asc) }
  scope :in_inverse_order, -> { lazily_order(:name, :desc) }

  delegate :supports_extract_records?, :supports_extract_record?, :supports_extract_sets?,
    allow_nil: true,
    to: :harvest_protocol

  after_create :check_and_maybe_extract_sets!

  after_update :check_and_maybe_extract_sets!, if: :saved_change_to_base_url?

  validates :identifier, uniqueness: true
  validates :identifier, :name, :base_url, presence: true
  validates :base_url, url: true

  monadic_operation! def assign_metadata_mapping(field, pattern, target_entity)
    call_operation("harvesting.metadata_mappings.assign", self, field, pattern, target_entity)
  end

  monadic_operation! def assign_metadata_mappings(raw_mappings, base_entity:)
    call_operation("harvesting.metadata_mappings.assign_many_by_identifier", self, raw_mappings, base_entity:)
  end

  # @see HarvestProtocol.context_for
  # @return [Harvesting::Protocols::Context]
  def build_protocol_context
    HarvestProtocol.context_for(self)
  end

  # @see Harvesting::Sources::Check
  # @see Harvesting::Sources::Checker
  # @return [Dry::Monads::Success(void)]
  monadic_operation! def check
    call_operation("harvesting.sources.check", self)
  end

  # @return [void]
  monadic_operation! def extract_sets
    call_operation("harvesting.sources.extract_sets", self)
  end

  # @param [String] identifier
  # @return [HarvestSet, nil]
  def set_by_identifier(identifier)
    call_operation("harvesting.sources.find_set_by_identifier", self, identifier).value_or(nil)
  end

  # @param [String] identifier
  # @return [Dry::Monads::Success(HarvestSet)]
  monadic_operation! def upsert_set(identifier)
    call_operation("harvesting.sources.upsert_set", self, identifier)
  end

  private

  # @return [void]
  def check_and_maybe_extract_sets!
    check!

    return unless active? && supports_extract_sets?

    Harvesting::Sources::ExtractSetsJob.perform_later(self)
  end

  class << self
    # @param [HarvestSource, String] identifier
    # @raise [Harvesting::Sources::Unknown]
    # @return [HarvestSource]
    def fetch!(identifier)
      identified_by(identifier).first!
    rescue ActiveRecord::RecordNotFound
      raise Harvesting::Sources::Unknown, identifier
    end
  end
end
