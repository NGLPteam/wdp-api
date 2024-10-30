# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::ContributorListDefinition
      # @see Templates::Config::TemplateSlots::ContributorListSlots
      # @see Templates::SlotMappings::ContributorListDefinition
      class ContributorList < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :contributor_list

        attribute :background, ::Templates::Config::Properties::ContributorListBackground, default: -> { "none" }

        attribute :limit, ::Templates::Config::Properties::Limit, default: -> { 3 }

        attribute :slots, Templates::Config::TemplateSlots::ContributorListSlots,
          default: -> { Templates::Config::TemplateSlots::ContributorListSlots.new }

        xml do
          root "contributor-list"

          map_attribute "background", to: :background

          map_element "limit", to: :limit

          map_element "slots", to: :slots
        end
      end
    end
  end
end
