# frozen_string_literal: true

module Templates
  module Definitions
    class TemplateKind < Templates::Definitions::AbstractEnumValue
      accepts_enum! ::Templates::Types::TemplateKind
    end
  end
end
