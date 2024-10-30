# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::HeroDefinition
    # @see Templates::Config::TemplateSlots::HeroSlots
    # @see Templates::SlotMappings::HeroInstanceSlots
    class HeroDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::HeroInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("hero#header") }
      inline! :header_aside
      block! :header_sidebar
      block! :header_summary, default: proc { TemplateSlot.default_template_hash_for("hero#header_summary") }
      inline! :subheader
      inline! :subheader_aside
      block! :subheader_summary
      block! :sidebar, default: proc { TemplateSlot.default_template_hash_for("hero#sidebar") }
      inline! :metadata, default: proc { TemplateSlot.default_template_hash_for("hero#metadata") }
      block! :summary, default: proc { TemplateSlot.default_template_hash_for("hero#summary") }
      inline! :call_to_action
    end
  end
end
