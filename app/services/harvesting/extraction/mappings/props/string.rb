# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        # @abstract
        class String < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :string

          xml do
            root "string"
          end
        end
      end
    end
  end
end
