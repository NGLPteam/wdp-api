# frozen_string_literal: true

# Helper methods for defining associations that rely on a tuple.
module EntityAdjacentAssociations
  extend ActiveSupport::Concern

  # @api private
  ENTITY_ADJACENT_TUPLE = %i[entity_type entity_id].freeze

  class_methods do
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
