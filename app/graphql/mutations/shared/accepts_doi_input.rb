# frozen_string_literal: true

module Mutations
  module Shared
    # A mutation that accepts a DOI argument.
    module AcceptsDOIInput
      extend ActiveSupport::Concern

      included do
        argument :doi, String, required: false, description: "", attribute: true do
          description <<~TEXT
          Digital Object Identifier (see: https://doi.org)

          **Note**: This actually gets assigned to the entity's `rawDOI`, and will be sanitized to get set on `DOI`.
          TEXT
        end
      end
    end
  end
end
