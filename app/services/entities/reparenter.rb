# frozen_string_literal: true

module Entities
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
  # @see Schemas::Instances::ReparentEntity
  # @see Entities::Reparent
  class Reparenter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :parent, Entities::Types::Entity
      param :child, Entities::Types::Entity
    end

    include MeruAPI::Deps[
      build_child_attributes: "schemas.edges.build_child_attributes",
    ]

    # @return [Hash]
    attr_reader :attributes

    # @return [HierarchicalEntity, nil]
    attr_reader :old_parent

    standard_execution!

    after_execute :audit_authorizing!

    # @return [Dry::Monads::Success(HierarchicalEntity)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield assign_new_parent!
      end

      Success child
    end

    wrapped_hook! def prepare
      @attributes = {}
      @old_parent = child.hierarchical_parent

      super
    end

    wrapped_hook! def assign_new_parent
      @attributes = yield build_child_attributes.(parent, child)

      child.assign_attributes attributes

      # This should never fail under normal circumstances.
      child.save!

      super
    end

    private

    # @return [void]
    def audit_authorizing!
      Entities::AuditAuthorizingJob.perform_later
    end
  end
end
