# frozen_string_literal: true

class HarvestAttemptRecordLink < ApplicationRecord
  include TimestampScopes

  belongs_to :harvest_attempt, inverse_of: :harvest_attempt_record_links
  belongs_to :harvest_record, inverse_of: :harvest_attempt_record_links
end
