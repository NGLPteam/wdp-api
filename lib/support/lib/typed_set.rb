# frozen_string_literal: true

module Support
  # @abstract
  #
  # A typed set of objects that handles inline additions
  # for use with class-inherited attributes.
  #
  # Set up a subclass with `Support::TypedSet.of(SomeType)`.
  #
  # Include it in a class and define some helper methods
  # by doing something like:
  #
  # @example
  #   class SomeClass
  #     extend Support::TypedSet.of(CustomTypes::MethodName)[:methods]
  #   end
  class TypedSet
    extend Dry::Core::ClassAttributes

    include Enumerable

    delegate :each, to: :@elements

    DRY_TYPE = Dry::Types::Nominal.new(Dry::Types::Type).constrained(type: Dry::Types::Type)

    defines :array_type, type: DRY_TYPE
    defines :element_type, type: DRY_TYPE

    array_type Dry::Types["coercible.array"].of(DRY_TYPE)
    element_type Dry::Types["any"]

    # @param [Array] raw_elements
    def initialize(*raw_elements)
      @elements = coerce_array(raw_elements.flatten).freeze
    end

    # @param [Object] raw_element
    # @return [Support::TypedSet]
    def add(raw_element)
      element = coerce raw_element

      unless element.in?(@elements)
        new_elements = [*@elements, element]

        return self.class.new(new_elements)
      else
        return self
      end
    end

    def each
      return enum_for(__method__) unless block_given?

      @elements.each do |element|
        yield element
      end

      return self
    end

    # Inclusion checks will coerce incoming values first,
    # so a collection of symbols will handle `"foo".in?(set)`.
    #
    # @param [Object] raw_element
    def include?(raw_element)
      element = coerce raw_element

      super(element)
    rescue InvalidElement
      # :nocov:
      false
      # :nocov:
    end

    private

    # @param [Array] elements
    # @raise Support::TypedSet::InvalidElements
    # @return [Object] coerced by `array_type`
    def coerce_array(elements)
      self.class.array_type[elements].sort.uniq
    rescue Dry::Types::CoercionError, Dry::Types::ConstraintError
      raise InvalidElements, "Invalid element list for typed set: #{elements.inspect}"
    end

    # @param [Object] element
    # @raise Support::TypedSet::InvalidElement
    # @return [Object] coerced by `element_type`
    def coerce(element)
      self.class.element_type[element]
    rescue Dry::Types::CoercionError, Dry::Types::ConstraintError
      raise InvalidElement, "Invalid element for typed set: #{element.inspect}"
    end

    class << self
      # Set up a module that connects a typed set instance
      # to a class when extended.
      #
      # @param [Symbol] collection_name
      # @param [Hash] options
      # @rreturn [Support::TypedSets::Collected]
      def [](collection_name, **options)
        Support::TypedSets::Collected.new(self, collection_name, **options)
      end

      # @param [Dry::Types::Type] type
      # @return [Class<Support::TypedSet>]
      def of(type)
        Class.new(self).tap do |subklass|
          subklass.element_type type
          subklass.array_type Types::Coercible::Array.of(type)
          subklass.const_set :Type, Types.Instance(subklass)
        end
      end
    end

    class InvalidElement < TypeError; end

    class InvalidElements < TypeError; end
  end
end
