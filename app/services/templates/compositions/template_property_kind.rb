# frozen_string_literal: true

module Templates
  module Compositions
    # @see Templates::Types::PropertyKind
    class TemplatePropertyKind < ::Mappers::AbstractDryType
      accepts_type! Templates::Types::PropertyKind
    end
  end
end
