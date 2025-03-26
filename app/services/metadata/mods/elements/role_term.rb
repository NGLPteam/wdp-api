# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RoleTerm < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :type, :string, default: "text"

        attribute :code, method: :code?
        attribute :text, method: :text?

        xml do
          root "roleTerm"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "type", to: :type
        end

        def code?
          type == "code"
        end

        def text?
          type == "text" || !code?
        end
      end
    end
  end
end
