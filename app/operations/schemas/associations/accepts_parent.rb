# frozen_string_literal: true

module Schemas
  module Associations
    # Validate an array of associations for a given `child` entity
    # and check to see if it accepts `parent.
    #
    # @see Schemas::Associations::AnySatisfiedBy
    # @see Schemas::Associations::AnyAssociationSatisfier
    class AcceptsParent
      include Dry::Matcher.for(:call, with: Schemas::Associations::Matchers::Parent)
      include WDPAPI::Deps[satisfied_by: "schemas.associations.any_satisfied_by"]

      # @param [SchemaVersion] parent
      # @param [SchemaVersion] child
      # @return [Dry::Monads::Success(Schemas::Associations::Validations::Valid)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidParent)]
      def call(parent, child)
        associations = child.configuration.parents

        satisfied_by.call(associations, parent).either(TO_PARENT, TO_PARENT)
      end

      # Transform a {Schemas::Associations::Validations::Result} into a more specific type.
      #
      # @see Schemas::Associations::Validations::Invalid#to_parent
      TO_PARENT = ->(result) { result.to_parent.to_monad }

      private_constant :TO_PARENT
    end
  end
end
