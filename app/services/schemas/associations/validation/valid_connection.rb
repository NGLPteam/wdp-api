# frozen_string_literal: true

module Schemas
  module Associations
    module Validation
      class ValidConnection < Dry::Struct
        include Dry::Monads[:result]

        attribute :parent, Schemas::Associations::Validation::Valid
        attribute :child, Schemas::Associations::Validation::Valid

        def to_monad
          Success self
        end
      end
    end
  end
end
