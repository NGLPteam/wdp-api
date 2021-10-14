# frozen_string_literal: true

module Types
  class AnyAccessGrantSubjectType < Types::BaseUnion
    description "For a description of what this means, see AccessGrantSubject"

    possible_types "Types::UserGroupType", "Types::UserType"

    class << self
      def resolve_type(object, context)
        raise TypeError, "not a subject: #{object.inspect}" unless object.kind_of?(AccessGrantSubject)

        object.graphql_node_type
      end
    end
  end
end
