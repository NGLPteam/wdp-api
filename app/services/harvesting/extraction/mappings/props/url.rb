# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class URL < Harvesting::Extraction::Mappings::Props::Base
          attribute :label, :string
          attribute :href, :string

          render_attr! :label, :string

          render_attr! :href, :url

          xml do
            root "url"

            map_element "href", to: :href
            map_element "label", to: :label
          end
        end
      end
    end
  end
end
