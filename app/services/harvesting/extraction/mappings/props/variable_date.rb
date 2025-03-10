# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        # @abstract
        class VariableDate < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :variable_date

          xml do
            root "variable-date"
          end
        end
      end
    end
  end
end
