# frozen_string_literal: true

module Stacks
  class Stack
    include Dry::Initializer[undefined: true].define -> do
      param :parent, Stacks::Types::Parent
      param :name, Stacks::Types::Name

      option :coercer, Stacks::Types::Evaluable.optional, default: proc { nil }
      option :default, Stacks::Types::Evaluable.optional, default: proc { nil }
    end

    # @!attribute [r] current
    # @return [Object]
    def current
      stack.size > 0 ? stack.first : default_value
    end

    # @return [Object]
    def default_value
      evaluate default
    end

    # @!attribute [r] stack
    # @return [<Object>]
    def stack
      @stack ||= []
    end

    # Add an object to the stack for the duration of the block.
    #
    # @param [Object] new_entry
    # @yield [current] yield with the current stack
    # @yieldparam [Object] current the value from {#current}
    # @yieldreturn [void]
    # @return [void]
    def with(new_entry)
      entry = maybe_coerce new_entry

      stack.unshift entry

      yield current
    ensure
      stack.shift
    end

    # Override the stack with the default value for the duration of the block.
    #
    # @yield [current] yield with the current stack
    # @yieldparam [Object] current the {#default_value}.
    # @yieldreturn [void]
    # @return [void]
    def with_default
      with(default_value) do |current|
        yield current
      end
    end

    private

    def maybe_coerce(value)
      return value if coercer.nil?

      evaluate coercer, value
    end

    # @param [Symbol, Proc] callable
    # @param [<Object>] args
    def evaluate(callable, *args)
      case callable
      when Symbol
        evaluate_method(callable, *args)
      when Proc
        evaluate_proc(callable, *args)
      end
    end

    # @param [Proc] callable
    # @param [<Object>] args
    def evaluate_proc(callable, *args)
      if args.size > 0
        parent.instance_exec(*args, &callable)
      else
        parent.instance_eval(&callable)
      end
    end

    # @param [Symbol] callable
    # @param [<Object>] args
    def evaluate_method(callable, *args)
      parent.public_send(callable, *args)
    end
  end
end
