# frozen_string_literal: true

module Testing
  module GQL
    class ObjectsShaper
      def initialize(...)
        @items = []
      end

      def item(...)
        @items << build_item(...)

        return self
      end

      # @api private
      def build
        yield self if block_given?

        return compile
      end

      protected

      def build_item(...)
        ObjectShaper.build(...)
      end

      def compile
        return @items
      end

      class << self
        def build(*args, **kwargs, &)
          new(*args, **kwargs).build(&)
        end
      end
    end
  end
end
