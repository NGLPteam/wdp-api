# frozen_string_literal: true

module Types
  # @abstract
  class BaseArgument < GraphQL::Schema::Argument
    def initialize(*args, attribute: false, transient: false, **kwargs, &block)
      @attribute = attribute
      @transient = transient

      super(*args, **kwargs, &block)
    end

    def attribute?
      @attribute.present?
    end

    # @return [<String>]
    def attribute_names(names: [], parent: nil)
      argument_paths_for_if(&:attribute?)
    end

    # @param [<String>] names
    # @param [String, nil] parent
    # @yield [arg]
    # @yieldparam [Types::BaseArgument] arg
    # @yieldreturn [Boolean]
    # @return [<String>]
    def argument_paths_for_if(names: [], parent: nil, &block)
      argument_name = [parent, name].compact.join(?.)

      names << argument_name if yield(self)

      nested_arguments.each_with_object(names) do |arg, n|
        names += arg.argument_paths_for_if(names: n, parent: argument_name, &block) if yield(arg)
      end
    end

    # @api private
    # @return [<Types::BaseArgument>]
    def nested_arguments
      if type.respond_to?(:arguments)
        type.arguments.values
      elsif type.respond_to?(:of_type) && type.of_type.respond_to?(:arguments)
        type.of_type.arguments.values
      else
        []
      end
    end

    # @return [<Symbol>]
    def transient_arguments(names: [], parent: nil)
      argument_paths_for_if(&:transient?).map do |arg|
        arg.to_s.underscore.to_sym
      end
    end

    def transient?
      @transient
    end
  end
end
