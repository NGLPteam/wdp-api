# frozen_string_literal: true

module Utility
  # @see Utility::HashDecamelizer
  class DecamelizeHash
    include Support::Deps[
      actual: "utility.decamelize_hash",
    ]

    # @param [Hash] value
    # @return [Hash]
    def call(value)
      actual.(Hash(value))
    end
  end
end
