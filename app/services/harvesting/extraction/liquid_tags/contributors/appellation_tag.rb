# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class AppellationTag < AbstractPropertyCaptor
          only_for! :person

          attr_name :appellation
        end
      end
    end
  end
end
