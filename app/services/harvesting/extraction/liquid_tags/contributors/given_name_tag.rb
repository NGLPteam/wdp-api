# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class GivenNameTag < AbstractPropertyCaptor
          only_for! :person

          attr_name :given_name
        end
      end
    end
  end
end
