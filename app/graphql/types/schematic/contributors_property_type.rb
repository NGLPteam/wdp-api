# frozen_string_literal: true

module Types
  module Schematic
    class ContributorsPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :contributors, [Types::AnyContributorType, { null: false }], null: false, method: :value
    end
  end
end
