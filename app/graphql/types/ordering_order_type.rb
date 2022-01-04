# frozen_string_literal: true

module Types
  # An enum used to order {Ordering orderings}.
  #
  # @see Resolvers::OrderedAsOrdering
  class OrderingOrderType < Types::BaseEnum
    description "An enum used to order `Ordering`s. It uses `DETERMINISTIC` by default to ensure a consistent rendering experience."

    value "DETERMINISTIC", description: "Sort orderings by their static position of the ordering, falling back to the name if unset."
    value "RECENT", description: "Sort orderings by newest created date"
    value "OLDEST", description: "Sort orderings by oldest created date"
  end
end
