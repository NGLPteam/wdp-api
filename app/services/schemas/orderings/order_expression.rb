# frozen_string_literal: true

module Schemas
  module Orderings
    # The fully qualified order expression(s) from building an {Ordering} from
    # a {Schemas::Orderings::OrderDefinition}, along with any requisite joins.
    #
    # @see Schemas::Orderings::OrderBuilder::Compile
    class OrderExpression < Dry::Struct
      # @!attribute [r] joins
      # A mapping of join expressions that get attached to the {OrderingEntryCandidate.query_for candidate ordering process}.
      # @return [Hash]
      attribute :joins, Types::ArelJoinMap

      # @!attribute [r] default_orderings
      # @return [<Arel::Nodes::Ordering>]
      attribute :default_orderings, Types::ArelOrderings

      # @!attribute [r] inverse_orderings
      # @return [<Arel::Nodes::Ordering>]
      attribute :inverse_orderings, Types::ArelOrderings
    end
  end
end
