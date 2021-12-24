# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      # @abstract
      class Result < Dry::Struct
        include Dry::Monads[:result]

        attribute :requirements, Schemas::Associations::Types::Requirements

        attribute :provided_declaration, Schemas::Types::VersionDeclaration

        # @abstract
        # @return [Schemas::Associations::Validation::Result]
        def to_child; end

        # @abstract
        # @return [Schemas::Associations::Validation::Result]
        def to_parent; end

        # @abstract
        # @return [Dry::Monads::Result]
        def to_monad; end

        private

        def cast_to(other_klass)
          kind_of?(other_klass) ? self : other_klass.new(attributes)
        end

        def combine_into(klass, parent, child)
          klass.new(
            parent: parent.to_parent,
            child: child.to_child,
          )
        end

        def mutually_invalid(parent, child)
          combine_into Schemas::Associations::Validation::MutuallyInvalidConnection, parent, child
        end

        def valid_connection(parent, child)
          combine_into Schemas::Associations::Validation::ValidConnection, parent, child
        end
      end
    end
  end
end
