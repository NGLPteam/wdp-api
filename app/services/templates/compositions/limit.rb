# frozen_string_literal: true

module Templates
  module Compositions
    # Describing a limit for a given value
    class Limit < Shale::Type::Integer
      class << self
        def cast(value)
          return nil if value.blank?

          ::Templates::Types::LimitWithFallback[value]
        end
      end
    end
  end
end
