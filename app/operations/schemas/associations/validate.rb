# frozen_string_literal: true

module Schemas
  module Associations
    # Validate a connection between a parent and child {SchemaVersion schema}.
    #
    #
    # @see Schemas::Associations::AcceptsChild
    # @see Schemas::Associations::AcceptsParent
    # @see Schemas::Associations::Polymorphic::ValidateAssociation Polymorphic Interface
    class Validate
      include Dry::Matcher.for(:call, with: Schemas::Associations::Matchers::Connection)
      include Dry::Monads[:list, :result]
      include MeruAPI::Deps[
        accepts_parent: "schemas.associations.accepts_parent",
        accepts_child: "schemas.associations.accepts_child",
      ]

      # @param [SchemaVersion] parent
      # @param [SchemaVersion] child
      # @yield [matcher]
      # @yieldparam [Schemas::Associations::Matchers::Connection] matcher
      # @yieldreturn [void]
      # @return [Dry::Monads::Success(Schemas::Associations::Validations::ValidConnection)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidChild)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::InvalidParent)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::MutuallyInvalidConnection)]
      def call(parent, child)
        parent_accepted = accepts_parent.call(parent, child).to_validated

        child_accepted = accepts_child.call(parent, child).to_validated

        List::Validated[parent_accepted, child_accepted].traverse.to_result.either(COMBINE, COMBINE)
      end

      COMBINE = ->(results) { results.to_a.flatten.reduce(&:*).to_monad }

      private_constant :COMBINE
    end
  end
end
