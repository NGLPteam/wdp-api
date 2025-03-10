# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        class IdentifierTag < AbstractAttributeCaptor
          attr_name :identifier

          trackable false
        end
      end
    end
  end
end
