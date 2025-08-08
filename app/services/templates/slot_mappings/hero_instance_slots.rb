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
      block! :summary
    end
  end
end
