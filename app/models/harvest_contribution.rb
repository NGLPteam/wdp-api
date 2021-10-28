# frozen_string_literal: true

class HarvestContribution < ApplicationRecord
  belongs_to :harvest_contributor, inverse_of: :harvest_contributions
  belongs_to :harvest_entity, inverse_of: :harvest_contributions
end
