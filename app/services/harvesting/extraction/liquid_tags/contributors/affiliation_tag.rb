# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class AffiliationTag < AbstractPropertyCaptor
          only_for! :person

          attr_name :affiliation
        end
      end
    end
  end
end
