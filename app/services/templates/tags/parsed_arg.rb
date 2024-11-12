# frozen_string_literal: true

module Templates
  module Tags
    class ParsedArg
      using Templates::Tags::DropAccess

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

      # @param [Liquid::Context] context
      # @raise [Liquid::ContextError]
      # @return [Asset]
      def evaluate_asset(context)
        source = evaluate context

        asset_from source
      end

      # @param [Liquid::Context] context
      # @raise [Liquid::ContextError]
      # @return [HierarchicalEntity]
      def evaluate_entity(context)
        source = evaluate context

        entity_from source
      end

      private

      def asset_from(source)
        case source
        in ::Templates::Drops::AssetDrop
          asset_from(source.asset)
        in ::Asset
          source
        else
          raise Liquid::ContextError, "expected #{expression.inspect} to evaluate to an asset"
        end
      end

      def entity_from(source)
        case source
        in Templates::Drops::AbstractEntityDrop
          entity_from source.entity
        in HierarchicalEntity
          source
        else
          raise Liquid::ContextError, "expected #{expression.inspect} to evaluate to an entity"
        end
      end
    end
  end
end
