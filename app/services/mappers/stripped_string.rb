# frozen_string_literal: true

module Mappers
  # A shale type that ensures a string is always stripped of any excess whitespace on its edges.
  class StrippedString < Shale::Type::String
    class << self
      # @param [#to_s] value
      # @return [String, nil]
      def cast(value)
        value.to_s.strip.presence
      end
    end
  end
end
