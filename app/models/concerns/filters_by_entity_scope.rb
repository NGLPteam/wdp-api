# frozen_string_literal: true

# @see EntityDescendantScopeFilterType
# @see Resolvers::FiltersByEntityDescendantScope
module FiltersByEntityScope
  extend ActiveSupport::Concern

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

  class_methods do
    # @param [String, Symbol] name
    # @return [ActiveRecord::Relation<EntityDescendant>]
    def filtered_by_scope(name)
      return all if ALL.match? name

      return none unless name.in?(SCOPE_QUERIES)

      query = arel_quote SCOPE_QUERIES.fetch name

      expr = arel_infix ?~, arel_table[:scope], query

      where expr
    end
  end
end
