# frozen_string_literal: true

module Types
  class AccessGrantSubjectFilterType < Types::BaseEnum
    description "Filters a set of access grants by what type of subject they've granted access to"

    value "ALL", description: "All subject types"
    value "USER", description: "An individual user"
    value "GROUP", description: "A group of users. Not currently exposed"
  end
end
