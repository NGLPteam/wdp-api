# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Timestamp < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :timestamp

          xml do
            root "timestamp"
          end
        end
      end
    end
  end
end
