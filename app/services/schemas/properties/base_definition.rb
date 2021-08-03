# frozen_string_literal: true

module Schemas
  module Properties
    # @abstract
    class BaseDefinition
      include Dry::Core::Memoizable
      include Dry::Monads[:result]
      include StoreModel::Model

      attribute :path, :string
      attribute :type, :string

      # A hook method used to attach the property to a dry-schema.
      #
      # @abstract
      # @param [Dry::Schema::DSL] context
      # @see Schemas::Properties::CompileSchema
      # @return [void]
      def add_to_schema!(context); end

      # A hook method used when compiling the property into a dry-validation contract.
      # It should solely be used for adding rules, as the type-checking is handled by
      # {#add_to_schema!}.
      #
      # @abstract
      # @param [Dry::Validation::Contract] context
      # @see Schemas::Properties::CompileContract
      # @return [void]
      def add_to_rules!(context); end

      # @!attribute [r] key
      # Symbol version of {#path}.
      # @return [Symbol]
      def key
        path.to_sym
      end

      def group?
        type == "group"
      end

      def scalar?
        type != "group"
      end

      # A hook method for writing values to an entity
      #
      # @param [Schemas::Properties::WriteContext] context
      # @return [Dry::Monads::Result]
      def write_values_within!(context)
        Success nil
      end
    end
  end
end
