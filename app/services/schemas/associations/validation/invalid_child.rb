# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      # Specifically represents an invalid result for a `child` association.
      class InvalidChild < Schemas::Associations::Validation::Invalid
        def to_parent
          raise "#{self.class} cannot be applied to a parent context"
        end
      end
    end
  end
end
