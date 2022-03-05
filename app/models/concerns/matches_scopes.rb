# frozen_string_literal: true

module MatchesScopes
  extend ActiveSupport::Concern

  included do
    scope :matching_scopes, ->(*scopes) { build_matching_scopes_query_for(*scopes) }
  end

  module ClassMethods
    # @see ArelHelpers::ClassMethods#arel_ltree_matches_any_query
    # @param [<String>] scopes
    # @return [ActiveRecord::Relation]
    def build_matching_scopes_query_for(*scopes)
      scopes.flatten!

      return all if scopes.blank?

      where(arel_ltree_matches_any_query(:scope, *scopes))
    end
  end
end
