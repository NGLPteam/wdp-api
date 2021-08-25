# frozen_string_literal: true

module Types
  class BaseArgument < GraphQL::Schema::Argument
    def initialize(*args, attribute: false, **kwargs, &block)
      @attribute = attribute

      super(*args, **kwargs, &block)
    end

    def attribute?
      @attribute.present?
    end

    def attribute_names(names: [], parent: nil)
      attribute_name = [parent, name].compact.join(?.)

      names << attribute_name if attribute?

      nested_arguments.each_with_object(names) do |arg, n|
        names += arg.attribute_names(names: n, parent: attribute_name) if arg.attribute?
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
  end
end
