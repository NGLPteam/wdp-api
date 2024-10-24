# frozen_string_literal: true

module Templates
  module Definitions
    class LayoutKind < Templates::Definitions::AbstractEnumValue
      accepts_enum! ::Templates::Types::LayoutKind
    end
  end
end
