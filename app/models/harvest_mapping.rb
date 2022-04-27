# frozen_string_literal: true

class HarvestMapping < ApplicationRecord
  include HasEphemeralSystemSlug
  include HasHarvestingOptions
  include TimestampScopes

  belongs_to :harvest_source, inverse_of: :harvest_mappings
  belongs_to :harvest_set, inverse_of: :harvest_mappings, optional: true
  belongs_to :target_entity, inverse_of: :harvest_mappings, polymorphic: true

  scope :by_target, ->(entity) { where(target_entity: entity) }
  scope :by_set, ->(set) { where(harvest_set: set) }

  has_one_readonly :latest_harvest_attempt_link, inverse_of: :harvest_mapping

  has_many :harvest_attempts, inverse_of: :harvest_mapping, dependent: :destroy

  validates :metadata_format, harvesting_metadata_format: true

  before_validation :inherit_metadata_format!

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_source&.metadata_format
  end
end
