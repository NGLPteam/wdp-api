# frozen_string_literal: true

class HarvestMapping < ApplicationRecord
  include HasEphemeralSystemSlug

  belongs_to :harvest_source, inverse_of: :harvest_mappings
  belongs_to :harvest_set, inverse_of: :harvest_mappings, optional: true
  belongs_to :collection, inverse_of: :harvest_mappings

  has_many :harvest_attempts, inverse_of: :harvest_mapping, dependent: :destroy
end
