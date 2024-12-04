# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::HeroInstance
    # @see Templates::SlotMappings::HeroDefinitionSlots
    class HeroInstanceSlots < AbstractInstanceSlots
      inline! :big_search_prompt
      block! :call_to_action
      inline! :descendant_search_prompt
      inline! :header
      inline! :header_aside
      block! :header_sidebar
      block! :header_summary
      inline! :metadata
      block! :sidebar
      inline! :subheader
      inline! :subheader_aside
      block! :subheader_summary
      block! :summary
    end
  end
end
