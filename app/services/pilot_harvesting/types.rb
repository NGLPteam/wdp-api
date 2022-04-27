# frozen_string_literal: true

module PilotHarvesting
  # Types related to pilot
  module Types
    include Dry.Types

    SeedList = Types::Array.of(Types::String).default { [] }

    SourceURL = Types::String.constrained(http_uri: true)
  end
end
