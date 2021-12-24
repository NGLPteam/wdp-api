# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      # Representing an "invalid" association from {Schemas::Associations::AnyAssociationSatisfier}.
      class Invalid < Schemas::Associations::Validation::Result
        # @param [Schemas::Associations::Validation::Invalid] child
        # @return [Schemas::Associations::Validation::MutuallyInvalidConnection]
        def *(other)
          raise TypeError, "cannot combine with #{other.class}" unless other.kind_of?(Schemas::Associations::Validation::Invalid)

          if (child? ^ other.child?) && (parent? ^ other.parent?)
            if parent?
              mutually_invalid self, other
            else
              mutually_invalid other, self
            end
          elsif ((parent? || unspecified?) && other.unspecified?) || (unspecified? && (other.child? || other.unspecified?))
            mutually_invalid self, other
          elsif (child? || unspecified?) && (other.unspecified? || other.parent?)
            mutually_invalid other, self
          else
            raise TypeError, "cannot combine two results of the same type: #{self.class} && #{other.class}"
          end
        end

        def child?
          kind_of? Schemas::Associations::Validation::InvalidChild
        end

        def parent?
          kind_of? Schemas::Associations::Validation::InvalidParent
        end

        # @return [Schemas::Associations::Validation::InvalidChild]
        def to_child
          cast_to Schemas::Associations::Validation::InvalidChild
        end

        # @return [Schemas::Associations::Validation::InvalidParent]
        def to_parent
          cast_to Schemas::Associations::Validation::InvalidParent
        end

        def to_monad
          Failure self
        end

        def unspecified?
          !(child? || parent?)
        end
      end
    end
  end
end
