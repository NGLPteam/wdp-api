# frozen_string_literal: true

module Utility
  # Clean up a string with a number of regular expressions
  # and optionally stripping trailing/leading spaces.
  class StringCleaner
    include Dry::Initializer[undefined: false].define -> do
      option :substitutions, Utility::StringCleaning::Substitution::List
      option :strip, Dry::Types["params.bool"], default: proc { true }
    end

    # @param [String, #to_s] input
    # @return [String]
    def call(input)
      substitutions.reduce input.to_s do |sum, sub|
        sub.(sum)
      end.then do |out|
        strip ? out.strip : out
      end
    end

    class << self
      # Build a string cleaner programmatically.
      #
      # @yield [builder]
      # @yieldparam [Utility::StringCleaning::Builder] builder
      # @yieldreturn [void]
      # @return [Utility::StringCleaner]
      def build
        Utility::StringCleaning::Builder.new do |b|
          yield b if block_given?
        end.call
      end
    end
  end
end
