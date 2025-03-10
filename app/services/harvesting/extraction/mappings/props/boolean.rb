# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Boolean < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :bool

          xml do
            root "boolean"
          end
        end
      end
    end
  end
end
