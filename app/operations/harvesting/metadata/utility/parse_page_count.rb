# frozen_string_literal: true

module Harvesting
  module Metadata
    module Utility
      class ParsePageCount
        # @param [(Integer, Integer), (Integer, nil)] tuple
        # @return [Integer, nil]
        def call(tuple)
          case tuple
          in [Integer => fpage, Integer => lpage] if fpage < lpage
            lpage - fpage
          in [Integer, _]
            1
          else
            nil
          end
        end
      end
    end
  end
end
