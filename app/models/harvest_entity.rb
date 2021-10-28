# frozen_string_literal: true

# A staging ground for an {Item} or a {Collection}, extracted
# from metadata contained within a {HarvestRecord}.
class HarvestEntity < ApplicationRecord
  include ScopesForIdentifier

  has_closure_tree

  belongs_to :harvest_record, inverse_of: :harvest_entities

  belongs_to :entity, polymorphic: true, optional: true

  belongs_to :schema_version, optional: true

  has_one :harvest_attempt, through: :harvest_record

  has_many :harvest_contributions, inverse_of: :harvest_entity, dependent: :destroy

  attribute :extracted_assets, Harvesting::Assets::Mapping.to_type, default: proc { {} }

  validates :identifier, presence: true, uniqueness: { scope: :harvest_record_id }
end
