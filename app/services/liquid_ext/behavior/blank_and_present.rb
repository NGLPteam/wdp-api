# frozen_string_literal: true

module LiquidExt
  module Behavior
    module BlankAndPresent
      extend ActiveSupport::Concern

      # Rails-ish `blank?` predicate for use in liquid contexts.
      #
      # @return [Boolean]
      def is_blank
        # :nocov:
        blank_for_liquid?
        # :nocov:
      end

      # Rails-ish `present?` predicate for use in liquid contexts.
      #
      # @return [Boolean]
      def is_present
        # :nocov:
        !blank_for_liquid?
        # :nocov:
      end

      def to_liquid
        return nil if is_blank

        super
      end

      private

      # @abstract
      def blank_for_liquid?
        # :nocov:
        blank?
        # :nocov:
      end
    end
  end
end
