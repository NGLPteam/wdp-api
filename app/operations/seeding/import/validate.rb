# frozen_string_literal: true

module Seeding
  module Import
    class Validate
      include Dry::Core::Memoizable

      # @param [Hash] input
      # @return [Dry::Monads::Result]
      def call(input)
        contract.(input).to_monad
      end

      private

      memoize def contract
        ::Seeding::Contracts::Import.new
      end
    end
  end
end
