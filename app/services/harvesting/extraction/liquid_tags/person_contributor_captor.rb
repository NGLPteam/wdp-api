# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      # @abstract
      class PersonContributorCaptor < AbstractContributorCaptor
        contributor_kind :person
      end
    end
  end
end
