# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class Boolean < ::Mappers::AbstractDryType
        accepts_type! ::Templates::Types::Params::Bool.default(false).fallback(false)
      end
    end
  end
end
