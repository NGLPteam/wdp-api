# frozen_string_literal: true

module MutationOperations
  module Contracts
    extend ActiveSupport::Concern

    included do
      delegate :applicable_contracts, to: :class
    end

    # @api private
    # @return [void]
    def check_contracts!(**args)
      applicable_contracts.each do |contract|
        check_contract! contract, **args
      end
    end

    # @api private
    # @param [ApplicationContract] contract
    # @return [void]
    def check_contract!(contract, **args)
      result = contract.(**args)

      return true if result.success?

      result.errors.each do |error|
        add_error! error.text, path: error.path, code: error.predicate, force_attribute: true
      end
    end

    module ClassMethods
      # @api private
      # @return [<Dry::Validation::Contract>]
      def applicable_contracts
        @applicable_contracts ||= []
      end

      # @param [Class, Dry::Validation::Contract, String, Symbol] contract
      # @return [void]
      def use_contract!(contract)
        applicable_contracts << check_contract!(contract)
      end

      private

      # @param [Class, Dry::Validation::Contract] contract
      # @return [Dry::Validation::Contract]
      def check_contract!(contract)
        case contract
        when Dry::Validation::Contract then contract
        when AppTypes.Inherits(Dry::Validation::Contract) then contract.new
        when String, Symbol
          lookup_mutation_contract contract
        else
          raise TypeError, "#{contract.inspect} is not a valid contract"
        end
      end

      # @param [String, Symbol] name The name of an existing contract in the
      #   WDPAPI container (defined under "mutations.contracts.")
      # @return [Dry::Validation::Contract]
      def lookup_mutation_contract(name)
        full_name = "mutations.contracts.#{name}"

        check_contract! WDPAPI::Container[full_name]
      rescue Dry::Container::Error
        raise ArgumentError, "Could not find mutation contract: #{full_name}"
      end
    end
  end
end
