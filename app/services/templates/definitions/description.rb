# frozen_string_literal: true

module Templates
  module Definitions
    class Description < Shale::Mapper
      attribute :content, Templates::Definitions::StrippedString

      xml do
        root "description"

        map_content to: :content
      end
    end
  end
end
