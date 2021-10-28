# frozen_string_literal: true

class HarvestAttempt < ApplicationRecord
  include HasEphemeralSystemSlug
  include ScopesForMetadataFormat

  belongs_to :collection, inverse_of: :harvest_attempts
  belongs_to :harvest_source, inverse_of: :harvest_attempts
  belongs_to :harvest_set, inverse_of: :harvest_attempts, optional: true
  belongs_to :harvest_mapping, inverse_of: :harvest_attempts, optional: true

  has_many :harvest_records, inverse_of: :harvest_attempt, dependent: :destroy

  has_many :harvest_entities, through: :harvest_records

  validates :metadata_format, harvesting_metadata_format: true

  before_validation :inherit_metadata_format!

  def logger
    @logger ||= Harvesting::Logs::Attempt.new self
  end

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_mapping&.metadata_format || harvest_source&.metadata_format
  end
end
