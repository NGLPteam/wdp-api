# frozen_string_literal: true

module TestHelpers
  # This sets up a number of helpers in an RSpec context
  # related to setting values for a hash that can be easily
  # overridden, while also providing access to the values
  # with a direct `let` expression.
  class HashSetter < Module
    include Dry::Initializer[undefined: false].define -> do
      param :hash_name, Dry::Types["coercible.string"]
      option :singularize_suffix, Dry::Types["bool"], default: proc { true }
      option :suffix, Dry::Types["coercible.string"], default: proc { singularize_suffix ? hash_name.singularize : hash_name }
      option :let_method_name, Dry::Types["coercible.symbol"], default: proc { :"let_#{suffix}!" }
      option :set_method_name, Dry::Types["coercible.symbol"], default: proc { :"set_#{suffix}!" }
      option :key_set_name, Dry::Types["coercible.symbol"], default: proc { :"#{suffix}_key_set" }
    end

    attr_reader :klass_methods

    def initialize(*)
      super

      define_methods!
    end

    def included(base)
      base.extend @klass_methods

      base.class_eval <<~RUBY, __FILE__, __LINE__ + 1
      let!(:#{hash_name}) do
        self.class.#{key_set_name}.each_with_object(default_#{hash_name}) do |(name, key), h|
          h[key] = __send__(name)
        end
      end
      RUBY
    end

    private

    # @return [void]
    def define_methods!
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def default_#{hash_name}
        {}
      end

      def #{set_method_name}(key, value)
        #{hash_name}[key] = value

        return value
      end
      RUBY

      @klass_methods = Module.new

      const_set :ClassMethods, @klass_methods

      @klass_methods.class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{key_set_name}
        @#{key_set_name} ||= {}
      end

      def inherited(subclass)
        super if defined? super

        #{key_set_name}.each do |name, key|
          subclass.#{key_set_name}[name] = key
        end
      end

      def #{let_method_name}(name, key: name, &block)
        #{key_set_name}[name.to_sym] = key.to_sym

        let!(name, &block)
      end
      RUBY
    end
  end
end
