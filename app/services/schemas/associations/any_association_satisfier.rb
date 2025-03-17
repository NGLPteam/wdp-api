# frozen_string_literal: true

module Schemas
  module Associations
    # @api private
    # @see Schemas::Associations::AnySatisfiedBy
    class AnyAssociationSatisfier
      include Dry::Monads[:list, :result]
      include Dry::Initializer[undefined: false].define -> do
        param :associations, Types::Associations
        param :schema, Types::Schema
        param :satisfier, Types::Operation
      end

      delegate :declaration, to: :schema, prefix: :provided

      # @return [Dry::Monads::Success(Schemas::Associations::Validations::Valid)]
      # @return [Dry::Monads::Failure(Schemas::Associations::Validations::Invalid)]
      def call
        return valid_result if associations.none?

        attempts = associations.map do |association|
          satisfier.call(association, schema).or do
            Failure(association.requirement)
          end
        end

        successes, failures = attempts.partition(&:success?)

        if successes.any?
          traverse_over(successes).bind do |requirements|
            valid_result requirements
          end
        else
          traverse_over(failures).or do |requirements|
            invalid_result requirements
          end
        end
      end

      private

      def traverse_over(results)
        List::Result[*results].traverse.to_result
      end

      def for_result(requirements = [])
        Array(requirements).flatten.then do |reqs|
          { requirements: reqs, provided_declaration: }
        end
      end

      def valid_result(requirements = [])
        result = Schemas::Associations::Validation::Valid.new(for_result(requirements))

        Success result
      end

      def invalid_result(requirements = [])
        result = Schemas::Associations::Validation::Invalid.new(for_result(requirements))

        Failure result
      end
    end
  end
end
