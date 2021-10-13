# frozen_string_literal: true

class HarvestSource < ApplicationRecord
  include HasEphemeralSystemSlug

  has_many :harvest_attempts, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :harvest_source, dependent: :destroy
  has_many :harvest_sets, inverse_of: :harvest_source, dependent: :destroy

  KNOWN_KINDS = %w[oai].freeze
  KNOWN_SOURCE_FORMATS = %w[mods].freeze

  validates :name, :kind, :source_format, :base_url, presence: true
  validates :kind, inclusion: { in: KNOWN_KINDS }
  validates :source_format, inclusion: { in: KNOWN_SOURCE_FORMATS }

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
