# frozen_string_literal: true

module Seeding
  module Contracts
    # The contract for validating the root of an import process.
    class Import < Base
      json do
        required(:communities).array(:hash, Seeding::Contracts::CommunityImport.schema)
        required(:version).value(:import_version)
      end

      rule(:communities).each(contract: Seeding::Contracts::CommunityImport)
    end
  end
end
