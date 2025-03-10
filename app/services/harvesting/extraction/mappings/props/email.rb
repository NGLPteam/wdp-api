# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Email < Harvesting::Extraction::Mappings::Props::BaseScalar
          render_attr! :content, :string

          xml do
            root "email"
          end
        end
      end
    end
  end
end
