# frozen_string_literal: true

module Types
  module Schematic
    class ContributorPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :contributor, Types::AnyContributorType, null: true, method: :value
    end
  end
end
