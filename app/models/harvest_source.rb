# frozen_string_literal: true

class HarvestSource < ApplicationRecord
  include HasEphemeralSystemSlug
  include ScopesForMetadataFormat
  include TimestampScopes

  has_many :harvest_attempts, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_contributors, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_sets, inverse_of: :harvest_source, dependent: :destroy

  KNOWN_PROTOCOLS = %w[oai].freeze

  scope :for_protocol, ->(protocol) { where(protocol: protocol) }
  scope :with_oai_protocol, -> { for_protocol "oai" }

  validates :name, uniqueness: true
  validates :name, :protocol, :base_url, presence: true
  validates :protocol, inclusion: { in: KNOWN_PROTOCOLS }
  validates :metadata_format, harvesting_metadata_format: true

  def logger
    @logger ||= Harvesting::Logs::Source.new self
  end

  # @return [void]
  def extract_sets!
    call_operation("harvesting.sources.extract_sets", self)
  end

  # @param [String] identifier
  def set_by_identifier(identifier)
    call_operation("harvesting.sources.find_set_by_identifier", self, identifier).value_or(nil)
  end
end
