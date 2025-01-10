# frozen_string_literal: true

module Templates
  module Config
    module Utility
      class SlotValue < Shale::Mapper
        attribute :hide_when_empty, ::Shale::Type::Boolean

        attribute :raw_template, ::Mappers::StrippedString

        hsh do
          map "hide_when_empty", to: :hide_when_empty
          map "raw_template", to: :raw_template
        end

        xml do
          root "slot"

          map_attribute "hide-when-empty", to: :hide_when_empty, render_nil: false

          map_content to: :raw_template, cdata: true
        end
      end
    end
  end
end
