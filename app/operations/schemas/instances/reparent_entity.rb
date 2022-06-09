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
    # @see Schemas::Edges::Calculate
    # @see Schemas::Edges::ChildAttributesBuilder
    # @see Schemas::Edges::Edge
    class ReparentEntity
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include WDPAPI::Deps[
        build_child_attributes: "schemas.edges.build_child_attributes",
      ]

      # @param [HasSchemaDefinition] parent
      # @param [HasSchemaDefinition] child
      # @return [Dry::Monads::Success(ApplicationRecord)] the successfully-saved child record
      # @return [Dry::Monads::Failure(:unacceptable_edge, Schemas::Edges::Invalid)]
      def call(parent, child)
        yield valid_instances! parent, child

        attributes = yield build_child_attributes.(parent, child)

        child.assign_attributes attributes

        monadic_save child
      end

      private

      # @param [HasSchemaDefinition] parent
      # @param [HasSchemaDefinition] child
      # @return [void]
      def valid_instances!(parent, child)
        yield valid_instance! parent
        yield valid_instance! child

        Success true
      end

      # @param [HasSchemaDefinition] model
      # @return [void]
      def valid_instance!(model)
        Schemas::Types::SchemaInstance.try(model).to_monad
      end
    end
  end
end
