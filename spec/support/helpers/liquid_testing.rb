# frozen_string_literal: true

module LiquidTesting
  module Drops
    # @abstract
    class AbstractDrop < Liquid::Drop
      include LiquidExt::Behavior::BlankAndPresent
    end

    class RootDrop < AbstractDrop
      # @return [LiquidTesting::Drops::AlwaysBlankDrop]
      attr_reader :always_blank

      # @return [LiquidTesting::Drops::ChildDrop]
      attr_reader :child

      # @return [false]
      attr_reader :falsey_primitive

      def initialize
        @always_blank = AlwaysBlankDrop.new

        @child = ChildDrop.new

        @falsey_primitive = false
      end
    end

    class AlwaysBlankDrop < AbstractDrop
      def blank_for_liquid?
        true
      end
    end

    class ChildDrop < AbstractDrop
      # @return [LiquidTesting::Drops::GrandchildDrop]
      attr_reader :grandchild

      def initialize
        @grandchild = GrandchildDrop.new
      end
    end

    class GrandchildDrop < AbstractDrop; end
  end
end
