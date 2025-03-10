# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class LegalNameTag < AbstractPropertyCaptor
          only_for! :organization

          attr_name :legal_name
        end
      end
    end
  end
end
