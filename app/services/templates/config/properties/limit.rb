# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class Limit < ::Mappers::AbstractDryType
        accepts_type! ::Templates::Types::Limit
      end
    end
  end
end
