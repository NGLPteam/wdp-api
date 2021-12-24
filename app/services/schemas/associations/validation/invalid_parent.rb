# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      # Specifically represents an invalid result for a `parent` association.
      class InvalidParent < Schemas::Associations::Validation::Invalid
        def to_child
          raise "#{self.class} cannot be applied to a child context"
        end
      end
    end
  end
end
