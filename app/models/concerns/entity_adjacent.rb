# frozen_string_literal: true

# An interface for things that are representative of a {HierarchicalEntity}
# and have a polymorphic `entity` association that connects to a {Community},
# {Collection}, or {Item}.
#
# Using said connection, we can connect this model to things like {EntityVisibility},
# {NamedVariableDate}, {EntityOrderableProperty}, etc.
#
# @note if a model's association to a {HierarchicalEntity} is not named `entity`,
#   override {.entity_adjacent_primary_key} to ensure the associations are set
#   up properly.
module EntityAdjacent
  extend ActiveSupport::Concern

  include EntityAdjacentAssociations
  include ReferencesEntityVisibility
  include ReferencesNamedVariableDates

  included do
    entity_adjacent_foreign_key select_entity_adjacent_foreign_key
    entity_adjacent_primary_key select_entity_adjacent_primary_key

    has_many_entity_adjacent :announcements, -> { recent }
    has_many_entity_adjacent :entity_breadcrumbs, -> { order(depth: :asc) }
    has_one_entity_adjacent :entity_visibility
    has_many_entity_adjacent :named_ancestors, -> { in_default_order.preload(:ancestor) }, class_name: "EntityAncestor"
    has_many_entity_adjacent :named_variable_dates
    has_many_entity_adjacent :pages
  end
end
