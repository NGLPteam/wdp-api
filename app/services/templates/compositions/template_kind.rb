# frozen_string_literal: true

module Templates
  module Compositions
    class TemplateKind < ::Mappers::AbstractDryType
      accepts_type! ::Templates::Types::TemplateKind
    end
  end
end
