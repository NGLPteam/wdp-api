# frozen_string_literal: true

module Entities
  module Captors
    # @abstract
    class Abstract
      extend Dry::Core::ClassAttributes

      defines :base_name, :boolean_name, :set_name, type: ::Entities::Types::Symbol.optional
      defines :interface, type: Entities::Types.Instance(Entities::Captors::Interface).optional

      boolean_name :abstract_capture_entity
      set_name :abstract_entity_set

      interface nil

      def already_capturing?
        __send__(boolean_name).present?
      end

      # @!attribute [r] boolean_name
      # @return [Symbol]
      def boolean_name
        self.class.boolean_name
      end

      # @!attribute [r] set_name
      # @return [Symbol]
      def set_name
        self.class.set_name
      end

      # @return [void]
      def wrap!
        return yield if already_capturing?

        result = nil

        __send__(:"with_#{boolean_name}", true) do
          entities, result = __send__(:"with_#{set_name}", Set.new) do
            yield
          end

          entities.each do |entity|
            entity.reload
          rescue ActiveRecord::RecordNotFound
            # intentionally left blank
            # this could have been a failed transaction
            # which would result in an orphaned records
          else
            handle_each! entity
          end

          return result
        end
      end

      # @abstract
      # @param [HierarchicalEntity] entity
      # @return [void]
      def handle_each!(entity); end

      class << self
        # @param [Symbol] boolean
        # @param [Symbol] set
        # @return [void]
        def capture_with!(base)
          base_name base

          boolean_name :"capture_#{base_name}"

          set_name :"#{base_name}_set"

          include Dry::Effects::Handler.Reader(boolean_name)
          include Dry::Effects::Handler.State(set_name)
          include Dry::Effects.Reader(boolean_name, default: false)

          interface = Interface.new(base_name, boolean_name, set_name)

          self.interface interface

          const_set(:Interface, interface)
        end
      end
    end
  end
end
