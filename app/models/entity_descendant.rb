# frozen_string_literal: true

# A view that calculates all descendants for a specific {HierarchicalEntity entity}.
#
# It is independent of type and includes links, allowing a greater deal of flexibility
# in being able to look through an entity's entire hierarchy.
class EntityDescendant < ApplicationRecord
  ENTITY_ADJACENT_PRIMARY_KEY = %i[descendant_type descendant_id].freeze

  include EntityAdjacent
  include FiltersBySchemaVersion
  include View

  self.primary_key = %i[parent_type parent_id auth_path].freeze

  ValidDepth = Dry::Types["coercible.integer"].constrained(gt: 0)

  # The inverse
  # @return [HierarchicalEntity]
  belongs_to :parent, polymorphic: true, inverse_of: :entity_descendants

  # @return [HierarchicalEntity]
  belongs_to :descendant, polymorphic: true

  belongs_to :schema_version, inverse_of: :entity_descendants

  scope :by_max_depth, ->(value) { build_max_depth_scope_for(value) }
  scope :collections, -> { filtered_by_scope :collection }

  # A pattern for matching "all" scopes.
  ALL = /\Aall\z/.freeze

  # A collection of lquery specifiers for different levels of
  # @see https://www.postgresql.org/docs/13/ltree.html#id-1.11.7.30.5 `lquery`
  SCOPE_QUERIES = {
    any_entity: "collections|items",
    any_link: "*{1}.linked.collections|items",
    collection: "collections",
    collection_or_link: "*{,1}.linked{,1}.collections",
    item: "items",
    item_or_link: "*{,1}.linked{,1}.items",
    linked_collection: "*{1}.linked.collections",
    linked_item: "*{1}.linked.items",
  }.with_indifferent_access.freeze

  class << self
    # @param [String, Symbol] name
    # @return [ActiveRecord::Relation<EntityDescendant>]
    def filtered_by_scope(name)
      return all if ALL.match? name

      return none unless name.in?(SCOPE_QUERIES)

      query = arel_quote SCOPE_QUERIES.fetch name

      expr = arel_infix ?~, arel_table[:scope], query

      where expr
    end

    def build_max_depth_scope_for(value)
      case value
      when ValidDepth
        where arel_table[:relative_depth].lteq(value)
      end
    end

    # @return [ActiveRecord::Relation]
    def for_collection_filter
      collections.select(:descendant_id)
    end
  end
end
