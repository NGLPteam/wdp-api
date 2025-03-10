# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class FamilyNameTag < AbstractPropertyCaptor
          only_for! :person

          attr_name :family_name
        end
      end
    end
  end
end
