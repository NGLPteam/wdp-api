# frozen_string_literal: true

module Entities
  # @see Entities::AncestorCalculator
  class CalculateAncestors
    # @param [SyncsEntities] descendant
    # @return [Dry::Monads::Result]
    def call(descendant)
      Entities::AncestorCalculator.new(descendant).call
    end
  end
end
