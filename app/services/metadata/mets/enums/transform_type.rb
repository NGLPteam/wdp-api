# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class TransformType < ::Metadata::Shared::AbstractEnum
        values!(
          "decompression",
          "decryption",
        )
      end
    end
  end
end
