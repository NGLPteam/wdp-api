# frozen_string_literal: true

class HarvestMapping < ApplicationRecord
  include HarvestAttemptable
  include HasEphemeralSystemSlug
  include HasHarvestMetadataFormat
  include HasHarvestSource
  include HasHarvestingOptions
  include TimestampScopes

  belongs_to :harvest_source, inverse_of: :harvest_mappings
  belongs_to :harvest_set, inverse_of: :harvest_mappings, optional: true
  belongs_to :target_entity, inverse_of: :harvest_mappings, polymorphic: true

  has_one_readonly :latest_harvest_attempt_link, inverse_of: :harvest_mapping

  has_many :harvest_attempts, inverse_of: :harvest_mapping, dependent: :destroy

  has_many :harvest_configurations, inverse_of: :harvest_mapping, dependent: :nullify

  has_many :harvest_messages, inverse_of: :harvest_mapping, dependent: :nullify

  has_many :harvest_mapping_record_links, inverse_of: :harvest_mapping, dependent: :delete_all

  has_many :harvest_records, through: :harvest_record_mapping_links

  scope :by_target, ->(entity) { where(target_entity: entity) }
  scope :by_set, ->(set) { where(harvest_set: set) }

  scope :in_default_order, -> { in_recent_order }
  scope :in_inverse_order, -> { in_oldest_order }

  before_validation :inherit_metadata_format!

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_source&.metadata_format
  end
end
