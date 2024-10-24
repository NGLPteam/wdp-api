# frozen_string_literal: true

module Templates
  module Definitions
    class Configuration < Shale::Mapper
      attribute :template_kind, Templates::Definitions::TemplateKind

      attribute :props, Templates::Definitions::ConfigProperty, collection: true
      attribute :description, Templates::Definitions::Description
      attribute :layout_kind, Templates::Definitions::LayoutKind

      xml do
        root "config"

        map_attribute "layout", to: :layout_kind
        map_element "description", to: :description
        map_element "prop", to: :props
      end
    end
  end
end
