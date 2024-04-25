# frozen_string_literal: true

module Support
  module DryGQL
    class Typing < Support::FlexibleStruct
      include Dry::Core::Memoizable

      attribute :actual_type, Types::TypeReference
      attribute :loads, Types::TypeReference.optional.default(nil).fallback(nil)

      attribute? :array, Types::Bool.default(false)
      attribute? :array_member_null, Types::Bool.default(false)
      attribute? :description, Types::String.optional.default(nil).fallback(nil)
      attribute? :required, Types::Bool.default(false).fallback(false)

      def as_array
        self.class.new(attributes.merge(array: true))
      end

      def argument_options
        opts = { type:, required: }

        if loads.present?
          opts[:loads] = loads.kind_of?(String) ? loads.constantize : loads
        end

        opts[:description] = description if description.present?

        return opts
      end

      def input_key_for(base)
        return base.to_sym unless loads

        array ? :"#{base}_ids" : :"#{base}_id"
      end

      # @return [Class<GraphQL::Schema::Member>]
      # @return [String] a string reference to a GraphQL object class, for lazy-loading.
      # @return [(Class<GraphQL::Schema::Member>, Hash)]
      # @return [(String, Hash)] a string reference to a GraphQL object class, for lazy-loading.
      memoize def type
        return actual_type unless array

        array_options = { null: array_member_null }

        return [actual_type, array_options]
      end
    end
  end
end
