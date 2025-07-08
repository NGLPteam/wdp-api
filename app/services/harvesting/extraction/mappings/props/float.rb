# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Float < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :float

          validate_attr! :content do
            validates :output, numericality: true
          end

          xml do
            root "float"
          end
        end
      end
    end
  end
end
