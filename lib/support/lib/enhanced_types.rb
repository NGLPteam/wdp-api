# frozen_string_literal: true

module Support
  # Enhance a `Dry.Types` module with additional helpers.
  #
  # @note It should be `extended` rather than `included`.
  module EnhancedTypes
    Email = Dry::Types["string"].constrained(email: true)

    # An interface type that matches anything that responds to `#call`.
    Operation = Dry::Types["any"].constrained(respond_to: :call)

    class << self
      # @return [void]
      # @!parse [ruby]
      #   # An interface type that matches anything that responds to `#call`.
      #   Operation = Dry::Types["any"].constrained(respond_to: :call)
      def extended(mod)
        mod.const_set(:Email, Support::EnhancedTypes::Email)
        mod.const_set(:Operation, Support::EnhancedTypes::Operation)
      end
    end

    # Create a type that matches an exact class or one of its subclasses.
    #
    # @param [Class] kls
    # @return [Dry::Types::Sum::Constrained]
    def ClassOrSubclass(kls)
      is_klass = ::Dry::Types["class"].constrained(eql: kls)

      is_klass | Implements(kls)
    end

    # Create a type that matches a class that includes a given module
    # @param [Class, Module] mod
    # @return [Dry::Types::Type]
    def Implements(mod)
      ::Dry::Types["class"].constrained(lt: mod)
    end

    alias Inherits Implements

    # A type that can match a class, one of its subclasses, or an instance
    # of any of the former.
    #
    # @param [Class, Module] kls
    # @return [Dry::Types::Sum::Constrained]
    def InstanceOrClass(mod)
      instance = ::Dry::Types::Nominal.new(mod).constrained(type: mod)
      klass = ClassOrSubclass(mod)

      instance | klass
    end

    def ModelInstance(specific_model)
      Instance(ActiveRecord::Base).constrained(specific_model:)
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

    # The string version of {#enum_with_fallback}.
    #
    # @param [<String>] values
    # @param [String, nil] fallback (will default to first value)
    # @return [Dry::Types::Type]
    def string_enum(*values, fallback: nil)
      enum_with_fallback(*values, type: "coercible.string", fallback:)
    end

    # The symbol version of {#enum_with_fallback}.
    #
    # @param [<Symbol>] values
    # @param [Symbol, nil] fallback (will default to first value)
    # @return [Dry::Types::Type]
    def symbol_enum(*values, fallback: nil)
      enum_with_fallback(*values, type: "coercible.symbol", fallback:)
    end
  end
end
