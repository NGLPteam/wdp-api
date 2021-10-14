# frozen_string_literal: true

module Types
  module AccessGrantSubjectType
    include Types::BaseInterface

    description <<~TEXT
    An access grant subject is a person or group to which access for a specific entity
    (and all its children) has been granted.
    TEXT

    field :all_access_grants, resolver: Resolvers::AccessGrants::SubjectResolver,
      description: "A polymorphic connection for access grants from a subject"
  end
end
