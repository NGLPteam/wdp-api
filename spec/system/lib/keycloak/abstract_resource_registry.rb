# frozen_string_literal: true

module Testing
  module Keycloak
    class AbstractResourceRegistry
      extend Dry::Core::ClassAttributes

      include Enumerable

      defines :representation_klass, type: Testing::Types::Class

      representation_klass ::Representation

      # @param [Testing::Keycloak::GlobalRegistry] registry
      def initialize(global:)
        @representations = {}
      end

      def add_empty!(id)
        add_representation_for!(id)
      end

      # @param [String] id
      # @return [void]
      def delete(id)
        @representations.delete id
      end

      def each
        return enum_for(__method__) unless block_given?

        @representations.each_value do |value|
          yield value
        end
      end

      def exists?(id)
        @representations.key? id
      end

      def ids
        @representations.keys
      end

      # @param [String] id
      # @return [::Representation, nil]
      def lookup(id)
        @representations[id]
      end

      # @return [void]
      def reset!
        @representations.clear
      end

      private

      # @return [void]
      def add_representation_for!(id)
        representation = self.class.representation_klass.new

        representation.id = id

        yield representation if block_given?

        @representations[id] = representation
      end
    end
  end
end
