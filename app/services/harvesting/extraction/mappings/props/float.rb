# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Float < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :float

          xml do
            root "float"
          end
        end
      end
    end
  end
end
