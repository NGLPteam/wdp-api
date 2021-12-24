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
  end

  def to_entity_properties
    super.tap do |props|
      props["doi"] = doi
      props["issn"] = issn
      props["subtitle"] = subtitle
    end
  end
end