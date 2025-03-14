# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::ContributorListDefinition
      # @see Templates::Config::Template::ContributorList
      # @see Templates::SlotMappings::ContributorListDefinitionSlots
      class ContributorListSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :contributor_list

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("contributor_list#header") }

        xml do
          root "slots"

          map_element "header", to: :header, render_nil: true
        end
      end
    end
  end
end
