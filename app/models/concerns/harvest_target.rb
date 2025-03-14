# frozen_string_literal: true

# An interface for models that can be the target of a {HarvestMapping} or {HarvestAttempt}.
#
# In practice, a {Community} or a {Collection}.
#
# @see ::Types::HarvestTargetType
module HarvestTarget
  extend ActiveSupport::Concern

  included do
    has_many :harvest_attempts, as: :target_entity, dependent: :destroy
    has_many :harvest_configurations, as: :target_entity, dependent: :destroy
    has_many :harvest_mappings, as: :target_entity, dependent: :destroy
    has_many :harvest_metadata_mappings, as: :target_entity, dependent: :destroy
  end

  # @see Types::HarvestTargetKindType
  # @return ["community", "collection"]
  def harvest_target_kind
    model_name.singular
  end
end
