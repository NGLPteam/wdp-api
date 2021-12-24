# frozen_string_literal: true

# An interface for things that are representative of a {HierarchicalEntity}
# and have a polymorphic `entity` association that connects to a {Community},
# {Collection}, or {Item}.
#
# Using said connection, we can connect this model to things like {EntityVisibility},
# {NamedVariableDate}, {EntityOrderableProperty}, etc.
module EntityAdjacent
  extend ActiveSupport::Concern

  include ReferencesEntityVisibility
  include ReferencesNamedVariableDates

  # @api private
  ENTITY_ADJACENT_TUPLE = %i[entity_type entity_id].freeze

  included do
    has_many_entity_adjacent :entity_breadcrumbs, -> { order(depth: :asc) }
    has_one_entity_adjacent :entity_visibility
    has_many_entity_adjacent :named_ancestors, -> { in_default_order.preload(:ancestor) }, class_name: "EntityAncestor"
    has_many_entity_adjacent :named_variable_dates
  end

  module ClassMethods
    def has_many_entity_adjacent(name, *args, primary_key: ENTITY_ADJACENT_TUPLE, foreign_key: ENTITY_ADJACENT_TUPLE, **options)
      options[:primary_key] = primary_key
      options[:foreign_key] = foreign_key

      has_many name, *args, **options
    end

    def has_one_entity_adjacent(name, *args, primary_key: ENTITY_ADJACENT_TUPLE, foreign_key: ENTITY_ADJACENT_TUPLE, **options)
      options[:primary_key] = primary_key
      options[:foreign_key] = foreign_key

      has_one name, *args, **options
    end
  end
end
