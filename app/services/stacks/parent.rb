# frozen_string_literal: true

module Stacks
  module Parent
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :stack_definitions, type: Stacks::Types::Hash.map(Stacks::Types::Name, Stacks::Types.Instance(::Stacks::Definition))

      stack_definitions Hash.new
    end

    class_methods do
      # @param [Symbol] name
      # @param [Symbol, Proc, nil] coercer
      # @param [Symbol, Proc, nil] default
      # @return [void]
      # @!macro [attach] define_stack!
      #   @!method $1_stack
      #   @see Stacks::Definition#stack_for
      #   @return [Stacks::Stack]
      #
      #   @!method current_$1
      #   @see Stacks::Stack#current
      #   @return [Object]
      #
      #   @!method with_default_$1
      #   @see Stacks::Stack#with_default
      #   @return [void]
      #
      #   @!method with_$1
      #   @see Stacks::Stack#with
      #   @return [void]
      def define_stack!(name, coercer: nil, default: nil)
        definition = Stacks::Definition.new self, name, coercer: coercer, default: default

        new_definitions = stack_definitions.merge(definition.name => definition)

        stack_definitions new_definitions
      end
    end
  end
end
