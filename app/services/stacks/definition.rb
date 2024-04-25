# frozen_string_literal: true

module Stacks
  class Definition
    include Dry::Core::Memoizable
    include Dry::Core::Equalizer.new(:klass, :name)

    include Dry::Initializer[undefined: true].define -> do
      param :klass, Stacks::Types::Class

      param :name, Stacks::Types::Name

      option :default, Stacks::Types::Evaluable.optional, default: proc {}
      option :coercer, Stacks::Types::Evaluable.optional, default: proc {}
    end

    def initialize(...)
      super

      @instance_mod = Methods.new self

      klass.const_set @instance_mod.const_name, @instance_mod

      klass.include @instance_mod
    end

    def build_stack_method_name
      :"build_#{name}_stack"
    end

    def current_method_name
      :"current_#{name}"
    end

    def stack_ivar
      :"@#{stack_method_name}"
    end

    def stack_method_name
      :"#{name}_stack"
    end

    def with_default_method_name
      :"with_default_#{name}"
    end

    def with_method_name
      :"with_#{name}"
    end

    # @param [Stacks::Parent] parent
    # @return [Stacks::Stack]
    def stack_for(parent)
      Stacks::Stack.new(parent, name, default:, coercer:)
    end

    # @api private
    class Methods < Module
      # @return [Stacks::Definition]
      attr_reader :definition

      # @param [Stacks::Definition] definition
      def initialize(definition)
        @definition = definition

        define_method(definition.build_stack_method_name) do
          definition.stack_for self
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{definition.stack_method_name}
          #{definition.stack_ivar} ||= #{definition.build_stack_method_name}
        end

        def #{definition.current_method_name}
          #{definition.stack_method_name}.current
        end

        def #{definition.with_default_method_name}(&block)
          #{definition.stack_method_name}.with_default(&block)
        end

        def #{definition.with_method_name}(new_value, **opts, &block)
          #{definition.stack_method_name}.with(new_value, **opts, &block)
        end
        RUBY
      end

      def const_name
        "#{definition.name}_stack_methods".camelize(:upper).to_sym
      end
    end
  end
end
