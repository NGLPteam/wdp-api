# frozen_string_literal: true

module LiquidExt
  module Tags
    module ArgParsing
      extend ActiveSupport::Concern

      include Dry::Core::Constants

      included do
        extend Dry::Core::ClassAttributes

        defines :arg_names, type: LiquidExt::Types::ArgNames

        arg_names EMPTY_ARRAY
      end

      # @return [LiquidExt::Tags::ParsedArgs]
      attr_reader :args

      def initialize(tag_name, markup, tokens)
        super

        @args = LiquidExt::Tags::ParsedArgs.new(tag_name, markup, tokens, arg_names: self.class.arg_names)
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
