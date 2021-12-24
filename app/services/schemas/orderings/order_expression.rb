# frozen_string_literal: true

module Schemas
  module Orderings
    # The fully qualified order expression(s) from building an {Ordering} from
    # a {Schemas::Orderings::OrderDefinition}, along with any requisite joins.
    #
    # @see Schemas::Orderings::OrderBuilder::Compile
    class OrderExpression < Dry::Struct
      attribute :joins, Types::ArelJoinMap

      attribute :default_orderings, Types::ArelOrderings

      attribute :inverse_orderings, Types::ArelOrderings
    end
  end
end
