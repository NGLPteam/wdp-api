# frozen_string_literal: true

module Shared
  # Automatically generate `::Type` and `::List` types for any class that includes this.
  module Typing
    extend ActiveSupport::Concern

    included do
      type = Dry::Types::Nominal.new(self).constrained(type: self)

      const_set :Type, type

      list = Dry::Types["array"].of(type)

      const_set :List, list

      subclass = Dry::Types["class"].constrained(lteq: self)

      const_set :Subclass, subclass
    end

    class_methods do
      def map_type!(key: Dry::Types::Coercible::String, on: :Map)
        const_set on, Dry::Types["hash"].map(key, const_get(:Type))
      end
    end

    class << self
      # Allow our typing module to be applied to modules as well,
      # so we can more succinctly type interfaces.
      #
      # @param [Module] base
      # @return [void]
      def extend_object(mod)
        # :nocov:
        raise TypeError, "use #include for classes" if mod.kind_of?(Class)

        # Already extended
        return false if mod.singleton_class < self

        # :nocov:

        super

        mod.extend const_get(:ClassMethods)
        mod.class_eval(&@_included_block)
      end
    end
  end
end
