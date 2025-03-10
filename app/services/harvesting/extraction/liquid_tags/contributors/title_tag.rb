# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class TitleTag < AbstractPropertyCaptor
          only_for! :person

          attr_name :title
        end
      end
    end
  end
end
