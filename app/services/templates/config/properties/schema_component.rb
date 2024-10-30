# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class SchemaComponent < ::Mappers::AbstractDryType
        accepts_type! ::Schemas::Types::Component
      end
    end
  end
end
