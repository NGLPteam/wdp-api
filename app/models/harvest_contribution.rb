# frozen_string_literal: true

class HarvestContribution < ApplicationRecord
  belongs_to :harvest_contributor, inverse_of: :harvest_contributions
  belongs_to :harvest_entity, inverse_of: :harvest_contributions

  has_one :harvest_record, through: :harvest_entity

  scope :by_record, ->(record) { joins(:harvest_record).where(harvest_records: { id: record }) }
end
