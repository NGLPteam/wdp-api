# frozen_string_literal: true

module MutationOperations
  # This logic is directly included by {MutationOperations::Base} but is kept
  # in a separate module for organizational purposes.
  #
  # Contracts are used to validate input in a more flexible and declarative way
  # than ActiveRecord validations: ideally, the contracts should prevent any data
  # that could make an invalid model from ever even reaching the execution step
  # of a mutation.
  #
  # Contracts do not short-circuit by design. If a mutation has 5 contracts defined,
  # all 5 will run in order and must allow and account for potentially missing data.
  # This is so that an attempt to mutate something in the API gets as much feedback
  # as possible as to why it failed so the client may address issues and resubmit.
  module Contracts
    extend ActiveSupport::Concern

    included do
      delegate :applicable_contracts, to: :class
    end

    # The attribute error path for "base" errors, which should only
    # occur with certain model integrations.
    BASE_PATH = %i[base].freeze

    # The attribute error path for "global" errors from contracts,
    # which should generally be favored over {BASE_PATH}.
    GLOBAL_PATH = %i[$global].freeze

    # The combination of {BASE_PATH} and {GLOBAL_PATH},
    # used for inlining errors returned from contracts.
    GLOBAL_PATHS = [GLOBAL_PATH, BASE_PATH, [nil], [""]].freeze

    # Run all the contracts defined for this mutation within the `validations` => `contracts` substep.
    # @api private
    # @return [void]
    def check_contracts!
      applicable_contracts.each do |contract|
        check_contract! contract, **args
      end
    end

    # @api private
    # @param [ApplicationContract] contract
    # @param [{ Symbol => Object }] args the input arguments to validate against the contract
    # @return [void]
    def check_contract!(contract, **args)
      result = contract.(**args)

      return true if result.success?

      result.errors.each do |error|
        if error.path.in?(GLOBAL_PATHS)
          add_global_error! error.text
        else
          add_error! error.text, path: error.path, code: error.predicate, force_attribute: true
        end
      end
    end

    class_methods do
      # @!attribute [r] applicable_contracts
      # A sequential list of applicable contracts that are set on the mutation
      # and must all be valid in order for the mutation to execute.
      # @return [<Dry::Validation::Contract>]
      def applicable_contracts
        @applicable_contracts ||= []
      end

      # Set up an {.applicable_contracts applicable contract} for this mutation.
      #
      # @param [Class, Dry::Validation::Contract, String, Symbol] contract
      # @raise [TypeError] if provided with an unsuitable argument
      # @raise [ArgumentError] if provided with an unknown contract name
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
      #   MeruAPI container (defined under "mutations.contracts.")
      # @return [Dry::Validation::Contract]
      def lookup_mutation_contract(name)
        full_name = "mutations.contracts.#{name}"

        check_contract! MeruAPI::Container[full_name]
      rescue Dry::Container::Error
        raise ArgumentError, "Could not find mutation contract: #{full_name}"
      end
    end
  end
end
