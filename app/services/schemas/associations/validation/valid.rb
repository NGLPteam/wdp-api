# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      # Representing a "valid" association from {Schemas::Associations::AnyAssociationSatisfier}.
      class Valid < Schemas::Associations::Validation::Result
        # @param [Schemas::Associations::Validation::Valid] child
        # @return [Schemas::Associations::Validation::ValidConnection]
        def *(other)
          raise TypeError, "cannot combine with #{other.class}" unless other.kind_of?(Schemas::Associations::Validation::Valid)

          valid_connection self, other
        end

        def to_parent
          self
        end

        def to_child
          self
        end

        def to_monad
          Success self
        end
      end
    end
  end
end
