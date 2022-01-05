# frozen_string_literal: true

module Types
  # @abstract
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument

    # A module for making input objects automatically cast themselves to a Ruby hash.
    module AutoHash
      # @api private
      # @note A graphql-ruby hook method that transforms the input object before
      #   it is sent to be processed by mutation operations.
      # @return [Hash]
      def prepare
        to_h
      end
    end
  end
end
