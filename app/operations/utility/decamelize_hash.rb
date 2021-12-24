# frozen_string_literal: true

module Utility
  # @see Utility::HashDecamelizer
  class DecamelizeHash
    # @param [Hash] value
    # @return [Hash]
    def call(value)
      Utility::HashDecamelizer.new(value).call
    end
  end
end
