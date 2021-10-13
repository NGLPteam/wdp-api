# frozen_string_literal: true

class HarvestAttempt < ApplicationRecord
  include HasEphemeralSystemSlug

  belongs_to :collection, inverse_of: :harvest_attempts
  belongs_to :harvest_source, inverse_of: :harvest_attempts
  belongs_to :harvest_set, inverse_of: :harvest_attempts, optional: true
  belongs_to :harvest_mapping, inverse_of: :harvest_attempts, optional: true

  has_many :harvest_records, inverse_of: :harvest_attempt, dependent: :destroy

  def logger
    @logger ||= Harvesting::Logs::Attempt.new self
  end
end
