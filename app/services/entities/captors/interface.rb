# frozen_string_literal: true

module Entities
  module Captors
    class Interface < Module
      # @return [Symbol]
      attr_reader :base_name

      # @return [Symbol]
      attr_reader :boolean_name

      # @return [Symbol]
      attr_reader :set_name

      # @param [Symbol] base_name
      # @param [Symbol] boolean_name
      # @param [Symbol] set_name
      def initialize(base_name, boolean_name, set_name)
        @base_name = base_name
        @boolean_name = boolean_name
        @set_name = set_name

        set_up_effects!

        define_methods!
      end

      private

      # @return [void]
      def set_up_effects!
        include Dry::Effects.Reader(boolean_name, default: false)
        include Dry::Effects.State(set_name)

        alias_method :"#{boolean_name}?", boolean_name
      end

      def define_methods!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{base_name}_captured?(entity)
          return false unless #{boolean_name}?

          #{set_name} << entity

          return true
        end
        RUBY
      end
    end
  end
end
