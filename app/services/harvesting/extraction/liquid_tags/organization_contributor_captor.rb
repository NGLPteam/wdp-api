# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      # @abstract
      class OrganizationContributorCaptor < AbstractContributorCaptor
        contributor_kind :organization
      end
    end
  end
end
