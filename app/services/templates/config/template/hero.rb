# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::HeroDefinition
      # @see Templates::Config::TemplateSlots::HeroSlots
      # @see Templates::SlotMappings::HeroDefinition
      class Hero < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :hero

        attribute :background, ::Templates::Config::Properties::HeroBackground, default: -> { "none" }

        attribute :enable_descendant_browsing, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :enable_descendant_search, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :list_contributors, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_basic_view_metrics, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_big_search_prompt, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_breadcrumbs, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_doi, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_hero_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_sharing_link, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_split_display, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_thumbnail_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :slots, Templates::Config::TemplateSlots::HeroSlots,
          default: -> { Templates::Config::TemplateSlots::HeroSlots.new }

        xml do
          root "hero"

          map_element "background", to: :background

          map_element "enable-descendant-browsing", to: :enable_descendant_browsing

          map_element "enable-descendant-search", to: :enable_descendant_search

          map_element "list-contributors", to: :list_contributors

          map_element "show-basic-view-metrics", to: :show_basic_view_metrics

          map_element "show-big-search-prompt", to: :show_big_search_prompt

          map_element "show-breadcrumbs", to: :show_breadcrumbs

          map_element "show-doi", to: :show_doi

          map_element "show-hero-image", to: :show_hero_image

          map_element "show-sharing-link", to: :show_sharing_link

          map_element "show-split-display", to: :show_split_display

          map_element "show-thumbnail-image", to: :show_thumbnail_image

          map_element "slots", to: :slots
        end
      end
    end
  end
end
