# frozen_string_literal: true

module Types
  class PositionDirectionType < Types::BaseEnum
    description "An enum that describes sorting nodes by position in ascending or descending order."

    value "ASCENDING"
    value "DESCENDING"
  end
end
