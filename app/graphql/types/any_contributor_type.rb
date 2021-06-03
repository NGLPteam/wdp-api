# frozen_string_literal: true

module Types
  class AnyContributorType < Types::BaseUnion
    possible_types Types::OrganizationContributorType, Types::PersonContributorType

    class << self
      def resolve_type(object, context)
        raise TypeError, "not a contributor: #{object.inspect}" unless object.kind_of?(Contributor)

        object.graphql_node_type
      end
    end
  end
end
