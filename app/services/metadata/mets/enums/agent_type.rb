# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class AgentType < ::Metadata::Shared::AbstractEnum
        values!(
          "INDIVIDUAL",
          "ORGANIZATION",
          "OTHER"
        )
      end
    end
  end
end
