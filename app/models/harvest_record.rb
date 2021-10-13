# frozen_string_literal: true

class HarvestRecord < ApplicationRecord
  belongs_to :harvest_attempt, inverse_of: :harvest_records

  has_one :harvest_source, through: :harvest_attempt
  has_one :harvest_mapping, through: :harvest_attempt
  has_one :harvest_set, through: :harvest_attempt

  has_many :harvest_entities, inverse_of: :harvest_record, dependent: :destroy
end
