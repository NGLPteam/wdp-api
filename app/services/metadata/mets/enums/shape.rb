# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class Shape < ::Metadata::Shared::AbstractEnum
        values!(
          "RECT",
          "CIRCLE",
          "POLY"
        )
      end
    end
  end
end
