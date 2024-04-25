# frozen_string_literal: true

module Schemas
  module Edges
    # @see Schemas::Edges::ChildAttributesBuilder
    class BuildChildAttributes
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        calculate_edge: "schemas.edges.calculate",
      ]

      # @param [HasSchemaDefinition] parent
      # @param [HasSchemaDefinition] child
      # @return [Dry::Monads::Success(Hash)] (@see Schemas::Edges::ChildAttributesBuilder#call)
      # @return [Dry::Monads::Failure(:unacceptable_edge, Schemas::Edges::Invalid)]
      def call(parent, child)
        edge = yield calculate_edge.call parent.schema_kind, child.schema_kind

        attributes = Schemas::Edges::ChildAttributesBuilder.new(parent, edge).call

        Success attributes
      end
    end
  end
end
