# frozen_string_literal: true

module Seeding
  module Brokers
    module DSL
      # @abstract
      class Builder
        extend ActiveModel::Callbacks
        extend Dry::Core::ClassAttributes

        defines :klass, type: Dry::Types["class"]

        klass Dry::Struct

        define_model_callbacks :build

        def initialize(parent: nil)
          @parent = parent

          @attributes = {}
        end

        # @return [Dry::Struct, Object]
        def build(&)
          @attributes = {}

          run_callbacks :build do
            instance_eval(&)
          end

          attrs = @attributes.symbolize_keys

          self.class.klass.new attrs
        end

        # @param [String] key
        # @param [Object] value
        # @return [void]
        def attr!(key, value)
          @attributes[key] = value

          return self
        end

        # @param [String] key
        # @param [Class<Seeding::Brokers::DSL::Builder>] builder_klass
        # @yieldreturn [void]
        # @return [self]
        def build_nested(key, builder_klass, &)
          value = builder_klass.new(parent: self).build(&)

          attr! key, value
        end

        class << self
          # @return [void]
          def builds!(klass)
            self.klass klass
          end

          def builds_nested!(key, with:, as: key.to_sym)
            define_method(as) do |&block|
              build_nested(key, with, &block)
            end
          end
        end
      end
    end
  end
end
