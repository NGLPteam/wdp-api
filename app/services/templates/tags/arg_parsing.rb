# frozen_string_literal: true

module Templates
  module Tags
    module ArgParsing
      extend ActiveSupport::Concern

      include Dry::Core::Constants

      included do
        extend Dry::Core::ClassAttributes

        defines :arg_names, type: Templates::Tags::Types::ArgNames

        arg_names EMPTY_ARRAY
      end

      MARKUP_PATTERN = /
        (?:
        (?:"[^"]+?")
        |
        (?:'[^']+?')
        |
        (?:[^,]+\s*)
        )
      /x

      KWARG_PATTERN = /\A\s*(?<name>[^:[:space:]]+):\s*(?<expression>.+)\z/

      # @return [Templates::Tags::ParsedArgs]
      attr_reader :args

      def initialize(tag_name, markup, tokens)
        super

        @args = Templates::Tags::ParsedArgs.new(tag_name, markup, tokens, arg_names: self.class.arg_names)
      end

      module ClassMethods
        def args!(*names)
          names.flatten!

          arg_names names.freeze
        end
      end
    end
  end
end
