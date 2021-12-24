# frozen_string_literal: true

module Schemas
  module Edges
    # @api private
    # An error that gets raised when providing things that do not correspond
    # to any known {Schemas::Types::Kind}. It should not naturally occur from
    # user interaction, and signals something is off with validating schemas.
    class Incomprehensible < StandardError
      # @!attribute [r] parent
      # The provided parent
      # @return [Object]
      attr_reader :parent

      # @!attribute [r] child
      # The provided child
      # @return [Object]
      attr_reader :child

      # @!attribute [r] valid_parent
      # Whether {#parent} is valid according to {Schemas::Types::Kind}.
      # @return [Boolean]
      attr_reader :valid_parent

      # @!attribute [r] valid_child
      # Whether {#child} is valid according to {Schemas::Types::Kind}.
      # @return [Boolean]
      attr_reader :valid_child

      alias has_valid_parent? valid_parent
      alias has_valid_child? valid_child

      def initialize(parent, child)
        @parent = parent
        @child = child

        @valid_parent = Schemas::Types::Kind.try(parent).success?
        @valid_child = Schemas::Types::Kind.try(child).success?

        super("Could not calculate edge from #{parent.inspect} over #{child.inspect}")
      end
    end
  end
end
