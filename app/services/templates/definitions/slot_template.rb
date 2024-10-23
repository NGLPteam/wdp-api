# frozen_string_literal: true

module Templates
  module Definitions
    class SlotTemplate < Shale::Mapper
      attribute :content, ::Mappers::StrippedString

      xml do
        root "template"

        map_content to: :content, cdata: true
      end
    end
  end
end
