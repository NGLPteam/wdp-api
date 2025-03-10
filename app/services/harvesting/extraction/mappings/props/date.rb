# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Date < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :date

          xml do
            root "date"
          end
        end
      end
    end
  end
end
