# frozen_string_literal: true

module Types
  module Filtering
    PATTERN = /\A(?<model_name>\w+)FilterInput\z/

    class << self
      def accept!(klass)
        name = klass.graphql_name.to_sym

        remove_const name if const_defined?(name)

        const_set name, klass
      end

      def const_missing(const_name)
        case const_name
        when PATTERN
          model_name = Regexp.last_match[:model_name]

          model_scope = model_name.pluralize

          scope_name = "::Filtering::Scopes::#{model_scope}"

          scope_klass = scope_name.safe_constantize

          return super unless scope_klass

          scope_klass.input_object
        else
          # :nocov:
          super
          # :nocov:
        end
      end
    end
  end
end
