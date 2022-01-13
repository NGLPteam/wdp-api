# frozen_string_literal: true

# Helper methods for defining associations that rely on a tuple.
module EntityAdjacentAssociations
  extend ActiveSupport::Concern

  EntityAdjacentTupleSpec = AppTypes::Array.of(AppTypes::Coercible::Symbol).constrained(size: 2)

  included do
    extend Dry::Core::ClassAttributes

    defines :entity_adjacent_foreign_key, type: EntityAdjacentTupleSpec
    defines :entity_adjacent_primary_key, type: EntityAdjacentTupleSpec

    entity_adjacent_foreign_key select_entity_adjacent_foreign_key
    entity_adjacent_primary_key select_entity_adjacent_primary_key
  end

  # The default tuple for joining entity-adjacent models
  # with entity details like {NamedVariableDate}, etc.
  #
  # @api private
  # @see .entity_adjacent_primary_key
  ENTITY_ADJACENT_TUPLE = %i[entity_type entity_id].freeze

  class_methods do
    # @return [(Symbol, Symbol)] The name of the type column, followed by the name of the ID column.
    def select_entity_adjacent_foreign_key
      ENTITY_ADJACENT_TUPLE
    end

    # @abstract Override this for models that don't define their polymorphic
    #   {HierarchicalEntity entity} association as `entity_type, entity_id`.
    # @return [(Symbol, Symbol)] The name of the type column, followed by the name of the ID column.
    def select_entity_adjacent_primary_key
      const_defined?(:ENTITY_ADJACENT_PRIMARY_KEY) ? const_get(:ENTITY_ADJACENT_PRIMARY_KEY) : ENTITY_ADJACENT_TUPLE
    end

    # @!macro [attach] has_many_entity_adjacent
    #   @!parse ruby
    #     has_many $1, ${2--1}
    def has_many_entity_adjacent(name, *args, primary_key: entity_adjacent_primary_key, foreign_key: entity_adjacent_foreign_key, **options)
      options[:primary_key] = primary_key
      options[:foreign_key] = foreign_key

      has_many name, *args, **options
    end

    # @!macro [attach] has_one_entity_adjacent
    #   @!parse ruby
    #     has_one $1, ${2--1}
    def has_one_entity_adjacent(name, *args, primary_key: entity_adjacent_primary_key, foreign_key: entity_adjacent_foreign_key, **options)
      options[:primary_key] = primary_key
      options[:foreign_key] = foreign_key

      has_one name, *args, **options
    end
  end
end
