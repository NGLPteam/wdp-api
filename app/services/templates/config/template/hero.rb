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

        attribute :descendant_search_prompt, ::Templates::Config::Properties::String, default: -> { "Search" }

        attribute :enable_descendant_browsing, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :enable_descendant_search, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :list_contributors, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_basic_view_metrics, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_big_search_prompt, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_breadcrumbs, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_doi, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_hero_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_issn, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_sharing_link, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_split_display, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_thumbnail_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :slots, Templates::Config::TemplateSlots::HeroSlots,
          default: -> { Templates::Config::TemplateSlots::HeroSlots.new }

        xml do
          root "hero"

          map_attribute "background", to: :background

          map_attribute "enable-descendant-browsing", to: :enable_descendant_browsing

          map_attribute "enable-descendant-search", to: :enable_descendant_search

          map_attribute "list-contributors", to: :list_contributors

          map_attribute "show-basic-view-metrics", to: :show_basic_view_metrics

          map_attribute "show-big-search-prompt", to: :show_big_search_prompt

          map_attribute "show-breadcrumbs", to: :show_breadcrumbs

          map_attribute "show-doi", to: :show_doi

          map_attribute "show-hero-image", to: :show_hero_image

          map_attribute "show-issn", to: :show_issn

          map_attribute "show-sharing-link", to: :show_sharing_link

          map_attribute "show-split-display", to: :show_split_display

          map_attribute "show-thumbnail-image", to: :show_thumbnail_image

          map_element "descendant-search-prompt", to: :descendant_search_prompt

          map_element "slots", to: :slots
        end
      end
    end
  end
end
