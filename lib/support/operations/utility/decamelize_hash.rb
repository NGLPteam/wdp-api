# frozen_string_literal: true

module Support
  module Utility
    # @see Support::Utility::HashDecamelizer
    class DecamelizeHash
      # @param [Hash] value
      # @return [Hash]
      def call(value)
        Support::Utility::HashDecamelizer.new(value).call
      end
    end
  end
end
