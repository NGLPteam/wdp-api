# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class Role < ::Metadata::Shared::AbstractEnum
        values!(
          "CREATOR",
          "EDITOR",
          "ARCHIVIST",
          "PRESERVATION",
          "DISSEMINATOR",
          "CUSTODIAN",
          "IPOWNER",
          "OTHER"
        )
      end
    end
  end
end
