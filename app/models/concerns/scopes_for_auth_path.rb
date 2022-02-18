# frozen_string_literal: true

module ScopesForAuthPath
  extend ActiveSupport::Concern

  included do
    # @param [String] lquery
    scope :auth_path_matches, ->(lquery) { where(arel_ltree_matches(arel_table[:auth_path], lquery)) }
  end

  class_methods do
    # @param [#auth_path] hierarchical
    # @return [ActiveRecord::Relation]
    def descendants_of(hierarchical, depth: nil)
      lquery_expr = "#{hierarchical.auth_path}.*#{depth_selector_for(depth)}"

      lquery = arel_cast(lquery_expr, "lquery")

      where(arel_ltree_matches(arel_table[:auth_path], lquery))
    end

    def siblings_of(hierarchical)
      return where(depth: 1) if hierarchical.depth == 1

      child_path = hierarchical.auth_path

      parent_path = child_path[/\A(.+?)\.[^.]+\z/, 1]

      sibling_selector = "#{parent_path}.*{1}"

      auth_path_matches(sibling_selector).where.not(auth_path: child_path)
    end

    # @api private
    # @param [Integer, nil] depth
    # @return [String]
    def depth_selector_for(depth)
      case depth
      when 1 then "{1}"
      when 2.. then "{1,#{depth}}"
      else
        "{1,}"
      end
    end
  end
end
