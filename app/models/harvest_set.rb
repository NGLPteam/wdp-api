# frozen_string_literal: true

# A logical grouping of records in a {HarvestSource}
class HarvestSet < ApplicationRecord
  include HasEphemeralSystemSlug

  belongs_to :harvest_source, inverse_of: :harvest_sets

  has_many :harvest_attempts, inverse_of: :harvest_set, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :harvest_set, dependent: :destroy

  has_many_readonly :latest_harvest_attempt_links, inverse_of: :harvest_set

  scope :by_identifier, ->(identifier) { where(identifier:) }

  validates :identifier, uniqueness: { scope: %i[harvest_source_id] }
end
