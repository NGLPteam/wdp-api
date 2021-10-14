# frozen_string_literal: true

module Types
  module AccessibleType
    include Types::BaseInterface

    description "An accessible entity can be granted access directly"

    field :all_access_grants, resolver: Resolvers::AccessGrants::AccessibleResolver,
      description: "A polymorphic connection for access grants from an entity"
  end
end
