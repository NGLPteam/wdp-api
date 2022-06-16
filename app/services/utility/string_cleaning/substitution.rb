# frozen_string_literal: true

module Utility
  module StringCleaning
    # @api private
    #
    # A substitution entry for a {Utility::StringCleaner}.
    class Substitution < Dry::Struct
      include Shared::Typing

      attribute :pattern, AppTypes.Instance(::Regexp)
      attribute :replacement, Dry::Types["string"].default("").fallback("")

      # @param [String] input
      # @return [String]
      def call(input)
        input.gsub(pattern, replacement)
      end
    end
  end
end
