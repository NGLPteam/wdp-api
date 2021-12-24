# frozen_string_literal: true

module Schemas
  module Associations
    # Matchers for various association validators
    module Matchers
      # If matched, this will yield {Schemas::Associations::Validation::Valid}
      ValidCase = Dry::Matcher::Case.new do |result, _|
        if result.success? && result.success.kind_of?(Schemas::Associations::Validation::Valid)
          result.success
        else
          Dry::Matcher::Undefined
        end
      end

      private_constant :ValidCase

      # If matched, this will yield {Schemas::Associations::Validation::ValidConnection}
      ValidConnectionCase = Dry::Matcher::Case.new do |result, _|
        if result.success? && result.success.kind_of?(Schemas::Associations::Validation::ValidConnection)
          result.success
        else
          Dry::Matcher::Undefined
        end
      end

      private_constant :ValidConnectionCase

      # If matched, this will yield {Schemas::Associations::Validation::MutuallyInvalidConnection}
      MutuallyInvalidCase = Dry::Matcher::Case.new do |result|
        if result.failure? && result.failure.kind_of?(Schemas::Associations::Validation::MutuallyInvalidConnection)
          result.failure
        else
          Dry::Matcher::Undefined
        end
      end

      private_constant :MutuallyInvalidCase

      # If matched, this will yield {Schemas::Associations::Validation::InvalidChild}
      InvalidChildCase = Dry::Matcher::Case.new do |result|
        if result.failure? && result.failure.kind_of?(Schemas::Associations::Validation::InvalidChild)
          result.failure
        else
          Dry::Matcher::Undefined
        end
      end

      private_constant :InvalidChildCase

      # If matched, this will yield {Schemas::Associations::Validation::InvalidParent}
      InvalidParentCase = Dry::Matcher::Case.new do |result|
        if result.failure? && result.failure.kind_of?(Schemas::Associations::Validation::InvalidParent)
          result.failure
        else
          Dry::Matcher::Undefined
        end
      end

      private_constant :InvalidParentCase

      # A dry-matcher for handling the potential results of validating a connection
      # between a parent and a child.
      #
      # 1. `valid`: {Schemas::Associations::Validation::ValidConnection}
      # 2. `mutually_invalid`: {Schemas::Associations::Validation::MutuallyInvalidConnection}
      # 3. `invalid_child`: {Schemas::Associations::Validation::InvalidChild}
      # 4. `invalid_parent`: {Schemas::Associations::Validation::InvalidParent}
      #
      # @see Schemas::Associations::Validate
      Connection = Dry::Matcher.new(
        valid: ValidConnectionCase,
        mutually_invalid: MutuallyInvalidCase,
        invalid_child: InvalidChildCase,
        invalid_parent: InvalidParentCase,
      )

      # A dry-matcher for handling the potential results of validating a child association.
      #
      # 1. `valid`: {Schemas::Associations::Validation::Valid}
      # 2. `invalid`: {Schemas::Associations::Validation::InvalidChild}
      #
      # @see Schemas::Associations::AcceptsChild
      Child = Dry::Matcher.new(
        valid: ValidCase,
        invalid: InvalidChildCase,
      )

      # A dry-matcher for handling the potential results of validating a parent association.
      #
      # 1. `valid`: {Schemas::Associations::Validation::Valid}
      # 2. `invalid`: {Schemas::Associations::Validation::InvalidParent}
      #
      # @see Schemas::Associations::AcceptsParent
      Parent = Dry::Matcher.new(
        valid: ValidCase,
        invalid: InvalidParentCase,
      )
    end
  end
end
