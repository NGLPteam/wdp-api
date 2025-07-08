# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        # @abstract
        class Integer < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :integer

          xml do
            root "integer"
          end

          validate_attr! :content do
            validates :output, numericality: { only_integer: true }
          end
        end
      end
    end
  end
end
