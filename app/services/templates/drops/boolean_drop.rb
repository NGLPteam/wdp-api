# frozen_string_literal: true

module Templates
  module Drops
    class BooleanDrop < Templates::Drops::AbstractDrop
      # @return [Boolean]
      attr_reader :truthy

      alias yes truthy

      # @return [String]
      attr_reader :message

      alias to_s message

      # @return [Boolean]
      attr_reader :falsey

      alias no falsey

      # @param [Boolean] value
      def initialize(value)
        @truthy = value.present?
        @falsey = value.blank?

        @message = truthy ? "Yes" : "No"
      end
    end
  end
end
