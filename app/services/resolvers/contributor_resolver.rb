# frozen_string_literal: true

module Resolvers
  class ContributorResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::AnyContributorType.connection_type, null: false

    max_page_size 1000

    scope { object.present? ? object.contributors : Contributor.all }

    option :kind, type: Types::ContributorFilterKindType, default: "ALL"

    def apply_kind_with_all(scope)
      scope.all
    end

    def apply_kind_with_organization(scope)
      scope.organization
    end

    def apply_kind_with_person(scope)
      scope.person
    end
  end
end
