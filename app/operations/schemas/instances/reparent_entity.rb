# frozen_string_literal: true

module Schemas
  module Instances
    # A polymorphic service that is able to take two entities,
    # a parent and a child, and reassign the child to belong to
    # the parent.
    #
    # Validation of whether or not the parent can accept the child,
    # beyond whether or not it is a valid edge, should happen at a
    # higher level than this service.
    #
    # @see Entities::Reparent
    # @see Entities::Reparenter
    # @see Schemas::Edges::Calculate
    # @see Schemas::Edges::ChildAttributesBuilder
    # @see Schemas::Edges::Edge
    class ReparentEntity
      include MeruAPI::Deps[
        implementation: "entities.reparent",
      ]

      # @param [HasSchemaDefinition] parent
      # @param [HasSchemaDefinition] child
      # @return [Dry::Monads::Success(ApplicationRecord)] the successfully-saved child record
      # @return [Dry::Monads::Failure(:unacceptable_edge, Schemas::Edges::Invalid)]
      def call(parent, child)
        implementation.(parent, child)
      end
    end
  end
end
