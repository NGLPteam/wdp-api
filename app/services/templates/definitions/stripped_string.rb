# frozen_string_literal: true

module Templates
  module Definitions
    class StrippedString < Shale::Type::Value
      class << self
        # @param [#to_s] value
        # @return [String, nil]
        def cast(value)
          value.to_s.strip.presence
        end
      end
    end
  end
end
