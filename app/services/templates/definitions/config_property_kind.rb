# frozen_string_literal: true

module Templates
  module Definitions
    class ConfigPropertyKind < Shale::Type::Value
      def cast(value)
        value.to_s.presence
      end
    end
  end
end
