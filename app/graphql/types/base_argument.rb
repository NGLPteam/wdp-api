# frozen_string_literal: true

module Types
  # @abstract
  class BaseArgument < GraphQL::Schema::Argument
    # @abstract
    def initialize(*args, public_values: [], attribute: true, transient: false, replace_null_with_default: nil, **kwargs, &block)
      @attribute = attribute
      @transient = transient
      @public_values = Array(public_values).flatten

      replace_null_with_default = !kwargs[:default_value].nil? if replace_null_with_default.nil?

      super(*args, replace_null_with_default:, **kwargs, &block)
    end

    def attribute?
      @attribute.present?
    end

    # @return [<String>]
    def attribute_names(names: [], parent: nil)
      argument_paths_for_if(&:attribute?)
    end

    def authorized?(obj, arg_value, ctx)
      if should_check_public_values?(ctx)
        super && arg_value.in?(@public_values)
      else
        super
      end
    end

    def has_public_values?
      @public_values.present?
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

    def should_check_public_values?(ctx)
      has_public_values? && !ctx[:current_user]&.has_admin_access?
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
