# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::HeroDefinition
    # @see Templates::Config::TemplateSlots::HeroSlots
    # @see Templates::SlotMappings::HeroInstanceSlots
    class HeroDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::HeroInstanceSlots

      inline! :big_search_prompt, default: proc { TemplateSlot.default_template_hash_for("hero#big_search_prompt") }
      block! :call_to_action
      inline! :descendant_search_prompt, default: proc { TemplateSlot.default_template_hash_for("hero#descendant_search_prompt") }
      inline! :header, default: proc { TemplateSlot.default_template_hash_for("hero#header") }
      inline! :header_aside
      inline! :header_parent
      block! :header_sidebar
      inline! :header_subtitle
      block! :header_summary
      inline! :metadata
      block! :sidebar
      inline! :subheader
      inline! :subheader_aside
      inline! :subheader_subtitle
      block! :subheader_summary
      block! :summary, default: proc { TemplateSlot.default_template_hash_for("hero#summary") }
    end
  end
end
