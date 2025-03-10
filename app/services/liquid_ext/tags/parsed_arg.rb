# frozen_string_literal: true

module LiquidExt
  module Tags
    class ParsedArg
      include Dry::Initializer[undefined: false].define -> do
        option :value, Types::Any
        option :expression, Types::String

        option :name, Types::ArgName.optional, optional: true
        option :index, Types::Integer.optional, optional: true
        option :kwarg, Types::Bool, default: proc { name.present? && index.blank? }
        option :lookup, Types::Bool, default: proc { value.kind_of?(Liquid::VariableLookup) }
      end

      alias lookup? lookup

      # @param [Liquid::Context] context
      # @return [Object]
      def evaluate(context)
        if lookup?
          value.evaluate(context)
        else
          value
        end
      end
    end
  end
end
