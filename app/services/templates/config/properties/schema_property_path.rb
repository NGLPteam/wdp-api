# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class SchemaPropertyPath < ::Mappers::AbstractDryType
        accepts_type! ::Schemas::Properties::Types::FullPath
      end
    end
  end
end
