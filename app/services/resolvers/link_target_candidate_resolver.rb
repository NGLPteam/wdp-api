# frozen_string_literal: true

module Resolvers
  class LinkTargetCandidateResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    type Types::LinkTargetCandidateType.connection_type, null: false

    scope { object.present? ? object.link_target_candidates.preload(:target).order(title: :asc) : LinkTargetCandidate.none }

    option :kind, type: Types::LinkTargetCandidateFilterType, default: "ALL"

    option :title, type: String, default: "" do |scope, value|
      scope.matching_title(value)
    end

    def apply_kind_with_all(scope)
      scope.all
    end

    def apply_kind_with_collection(scope)
      scope.collections
    end

    def apply_kind_with_item(scope)
      scope.items
    end
  end
end
