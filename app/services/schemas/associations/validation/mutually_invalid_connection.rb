# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      class MutuallyInvalidConnection < Dry::Struct
        include Dry::Monads[:result]

        attribute :parent, Schemas::Associations::Validation::InvalidParent
        attribute :child, Schemas::Associations::Validation::InvalidChild

        def to_monad
          Failure self
        end
      end
    end
  end
end
