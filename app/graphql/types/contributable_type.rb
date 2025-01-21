# frozen_string_literal: true

module Types
  module ContributableType
    include Types::BaseInterface

    description "Something that can be contributed to"

    field :contribution_roles, Types::ContributionRoleConfigurationType, null: false do
      description "Look up contribution role configuration for this record."
    end

    field :contributors, resolver: Resolvers::ContributorResolver, description: "Contributors to this element"

    # @return [ContributionRoleConfiguration]
    def contribution_roles
      call_operation("contribution_roles.fetch_config", contributable: object).value_or(nil)
    end
  end
end
