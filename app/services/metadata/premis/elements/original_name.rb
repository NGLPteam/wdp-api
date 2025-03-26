# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class OriginalName < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :content, :string
        attribute :simple_link, :string

        xml do
          root "originalName", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute "simpleLink", to: :simple_link

          map_content to: :content
        end
      end
    end
  end
end
