# frozen_string_literal: true

module Templates
  module Definitions
    class ConfigPropertyKind < ::Mappers::AbstractDryType
      accepts_type! Templates::Types::PropertyKind
    end
  end
end
