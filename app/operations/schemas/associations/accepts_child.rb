# frozen_string_literal: true

module Schemas
  module Associations
    # Validate an array of associations for a given `parent` entity
    # and check to see if it accepts `child.
    #
    # @see Schemas::Associations::AnySatisfiedBy
    # @see Schemas::Associations::AnyAssociationSatisfier
    class AcceptsChild
      include Dry::Matcher.for(:call, with: Schemas::Associations::Matchers::Child)
      include WDPAPI::Deps[satisfied_by: "schemas.associations.any_satisfied_by"]

      # @param [SchemaVersion] parent
      # @param [SchemaVersion] child
      # @return [Dry::Monads::Success(Schemas::Associations::Validations::Valid)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidChild)]
      def call(parent, child)
        associations = parent.configuration.children

        satisfied_by.call(associations, child).either(TO_CHILD, TO_CHILD)
      end

      # Transform a {Schemas::Associations::Validations::Result} into a more specific type.
      #
      # @see Schemas::Associations::Validations::Invalid#to_child
      TO_CHILD = ->(result) { result.to_child.to_monad }

      private_constant :TO_CHILD
    end
  end
end
