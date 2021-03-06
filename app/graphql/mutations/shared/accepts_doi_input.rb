# frozen_string_literal: true

module Mutations
  module Shared
    # A mutation that accepts a DOI argument.
    module AcceptsDOIInput
      extend ActiveSupport::Concern

      included do
        argument :doi, String, required: false, description: "Digital Object Identifier (see: https://doi.org)", attribute: true
        argument :issn, String, required: false, description: "International Standard Serial Number (see: https://issn.org)", attribute: true
      end
    end
  end
end
