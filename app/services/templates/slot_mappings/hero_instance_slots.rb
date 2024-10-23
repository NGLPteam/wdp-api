# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::HeroInstance
    class HeroInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :header_aside
      block! :header_sidebar
      block! :header_summary
      inline! :subheader
      inline! :subheader_aside
      block! :subheader_summary
      block! :sidebar
      inline! :metadata
      block! :summary
      inline! :call_to_action
    end
  end
end
