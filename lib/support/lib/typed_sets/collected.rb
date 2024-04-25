# frozen_string_literal: true

module Support
  module TypedSets
    # Metaprogramming module that hooks up a {Support::TypedSet}
    # with a class. It should be extended onto the class.
    #
    # @api private
    # @see Support::TypedSet.[]
    class Collected < Module
      include Dry::Initializer[undefined: false].define -> do
        param :typed_set_klass, Types::Class.constrained(lteq: Support::TypedSet)

        param :collection_name, Types::MethodName

        option :singular_name, Types::MethodName, default: proc { collection_name.to_s.singularize }

        option :const_name, Types::ConstName, default: proc { "#{collection_name}_set".classify }
      end

      # @api private
      # @return [Dry::Types::Type]
      attr_reader :type

      def initialize(...)
        super

        @type = typed_set_klass::Type

        generate_klass_module!
        generate_instance_module!
      end

      def extended(klass)
        klass.extend Dry::Core::ClassAttributes

        klass.defines(collection_name, type:)

        klass.const_set const_name, typed_set_klass

        klass.__send__ collection_name, typed_set_klass.new

        klass.extend @klass_module

        klass.include @instance_module
      end

      private

      # @return [void]
      def generate_klass_module!
        @klass_module = Module.new.tap do |mod|
          mod.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def add_#{singular_name}!(raw_element)
            new_values = #{collection_name}.add(raw_element)

            self.#{collection_name} new_values

            return self
          end

          def has_#{singular_name}?(raw_element)
            raw_element.in? self.class.#{collection_name}
          end
          RUBY
        end
      end

      # @return [void]
      def generate_instance_module!
        @instance_module = Module.new.tap do |mod|
          mod.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def has_#{singular_name}?(raw_element)
            raw_element.in? self.class.#{collection_name}
          end

          def #{collection_name}
            self.class.#{collection_name}
          end
          RUBY
        end
      end
    end
  end
end
