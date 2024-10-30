# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ContributorListDefinition
    # @see Templates::Config::TemplateSlots::ContributorListSlots
    # @see Templates::SlotMappings::ContributorListInstanceSlots
    class ContributorListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ContributorListInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("contributor_list#header") }
    end
  end
end
