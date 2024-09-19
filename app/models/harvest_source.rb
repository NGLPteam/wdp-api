# frozen_string_literal: true

class HarvestSource < ApplicationRecord
  include GloballyUniqueIdentifier
  include HasEphemeralSystemSlug
  include HasHarvestingOptions
  include ScopesForMetadataFormat
  include TimestampScopes

  has_many :harvest_attempts, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_contributors, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_metadata_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_sets, inverse_of: :harvest_source, dependent: :destroy

  has_many_readonly :latest_harvest_attempt_links, inverse_of: :harvest_source

  has_many_readonly :latest_harvest_attempts, through: :latest_harvest_attempt_links,
    source: :harvest_attempt

  KNOWN_PROTOCOLS = %w[oai].freeze

  scope :for_protocol, ->(protocol) { where(protocol:) }
  scope :with_oai_protocol, -> { for_protocol "oai" }

  validates :name, uniqueness: true
  validates :identifier, :name, :protocol, :base_url, presence: true
  validates :protocol, inclusion: { in: KNOWN_PROTOCOLS }
  validates :metadata_format, harvesting_metadata_format: true

  monadic_operation! def assign_metadata_mapping(field, pattern, target_entity)
    call_operation("harvesting.metadata_mappings.assign", self, field, pattern, target_entity)
  end

  monadic_operation! def assign_metadata_mappings(raw_mappings, base_entity:)
    call_operation("harvesting.metadata_mappings.assign_many_by_identifier", self, raw_mappings, base_entity:)
  end

  def logger
    @logger ||= Harvesting::Logs::Source.new self
  end

  # @return [void]
  def extract_sets!
    call_operation("harvesting.actions.extract_sets", self)
  end

  # @param [String] identifier
  def set_by_identifier(identifier)
    call_operation("harvesting.sources.find_set_by_identifier", self, identifier).value_or(nil)
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
