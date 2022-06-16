# frozen_string_literal: true

module Utility
  module StringCleaning
    # @api private
    #
    # Builds a {Utility::StringCleaner}.
    class Builder
      # @param [Boolean] strip
      def initialize(strip: true)
        @substitutions = []
        @strip = strip

        yield self if block_given?
      end

      # Add a {Utility::StringCleaning::Substitution substitution rule}.
      #
      # @param [Regexp] pattern
      # @param [String] replacement
      # @return [void]
      def gsub(pattern, replacement)
        @substitutions << Utility::StringCleaning::Substitution.new(pattern: pattern, replacement: replacement)
      end

      # Add a substitution rule that replaces the provided pattern with `""`.
      #
      # @see {#gsub}
      # @param [Regexp] pattern
      # @return [void]
      def remove(pattern)
        gsub(pattern, "")
      end

      def call
        Utility::StringCleaner.new(substitutions: @substitutions, strip: @strip)
      end
    end
  end
end
