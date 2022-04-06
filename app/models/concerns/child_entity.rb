# frozen_string_literal: true

# An entity that exists below a {Community} in the hierarchy,
# i.e. {Collection} or {Item}.
module ChildEntity
  extend ActiveSupport::Concern

  include HasSchemaDefinition
  include HierarchicalEntity
  include ReferencesNamedVariableDates
  include WritesNamedVariableDates

  included do
    has_many :named_variable_dates, as: :entity, dependent: :destroy

    has_many :harvest_entities, as: :entity, dependent: :nullify
    has_many :harvest_records, through: :harvest_entities

    scope :unharvested, -> { where.not(id: HarvestEntity.existing_entity_ids) }
  end

  def to_entity_properties
    super.tap do |props|
      props["doi"] = doi
      props["issn"] = issn
      props["subtitle"] = subtitle
    end
  end
end
