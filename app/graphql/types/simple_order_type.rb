# frozen_string_literal: true

module Types
  class SimpleOrderType < Types::BaseEnum
    description "A generic enum for sorting models that don't have anything more specific implemented"

    value "RECENT", description: "Sort models by newest created date"
    value "OLDEST", description: "Sort models by oldest created date"
  end
end
