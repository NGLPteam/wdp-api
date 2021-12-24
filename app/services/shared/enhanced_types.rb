# frozen_string_literal: true

module Shared
  module EnhancedTypes
    extend ActiveSupport::Concern

    class << self
      def extended(obj)
        obj.const_set(:Operation, obj.Interface(:call))
      end
    end

    def ClassOrSubclass(kls)
      is_klass = ::Dry::Types["class"].constrained(eql: kls)

      is_klass | Implements(kls)
    end

    def Implements(mod)
      ::Dry::Types["class"].constrained(lt: mod)
    end

    alias Inherits Implements

    def InstanceOrClass(mod)
      instance = ::Dry::Types::Nominal.new(mod).constrained(type: mod)
      klass = ClassOrSubclass(mod)

      instance | klass
    end

    # @param [<Object>] values
    # @param [Object, nil] fallback (will default to first value)
    # @param ["coercible.string", "coercible.symbol"] type
    # @return [Dry::Types::Type]
    def enum_with_fallback(*values, type: "coercible.string", fallback: nil)
      values.flatten!

      fallback = fallback.presence_in(values) || values.first

      Dry::Types[type].default(fallback).enum(*values).fallback(fallback)
    end

    # @param [<String>] values
    # @param [String, nil] fallback (will default to first value)
    # @return [Dry::Types::Type]
    def string_enum(*values, fallback: nil)
      enum_with_fallback(*values, type: "coercible.string", fallback: fallback)
    end

    # @param [<Symbol>] values
    # @param [Symbol, nil] fallback (will default to first value)
    # @return [Dry::Types::Type]
    def symbol_enum(*values, fallback: nil)
      enum_with_fallback(*values, type: "coercible.symbol", fallback: fallback)
    end
  end
end
