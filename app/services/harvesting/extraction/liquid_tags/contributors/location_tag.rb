# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class LocationTag < AbstractPropertyCaptor
          only_for! :organization

          attr_name :location
        end
      end
    end
  end
end
