# frozen_string_literal: true

class HarvestEntity < ApplicationRecord
  include ScopesForIdentifier

  has_closure_tree

  belongs_to :harvest_record, inverse_of: :harvest_entities

  belongs_to :entity, polymorphic: true, optional: true

  belongs_to :schema_version, optional: true

  has_one :harvest_attempt, through: :harvest_record
end
