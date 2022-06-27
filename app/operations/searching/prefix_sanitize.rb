# frozen_string_literal: true

module Searching
  # Sanitize text for prefix searching.
  class PrefixSanitize
    # All non-alphanumeric characters
    FILTER = /[^[:alnum:]]/.freeze

    # @param [#to_s] text
    # @return [String]
    def call(text)
      text.to_s.gsub(FILTER, "").downcase
    end
  end
end
