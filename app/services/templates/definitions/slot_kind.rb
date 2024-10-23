# frozen_string_literal: true

module Templates
  module Definitions
    class SlotKind < Shale::Type::Value
      class << self
        # @see Templates::Types::SlotKind
        # @param ["inline", "block"] value
        # @return ["inline", "block"]
        def cast(value)
          ::Templates::Types::SlotKind[value]
        end
      end
    end
  end
end
