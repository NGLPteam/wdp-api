# frozen_string_literal: true

module Harvesting
  module Metadata
    module MODS
      # Parse individual `mods:Identifier` tags.
      class ParseIdentifier
        include Harvesting::Metadata::XMLExtraction
        include Dry::Effects.Resolve(:premis_items)
        include Dry::Monads[:result]

        error_context :mods_identifier_parsing

        add_xlink!

        default_namespace! Namespaces[:mods]

        extract_values! do
          xpath :value, "./text()", type: :string
          xpath :type, "./@type", type: :string

          on_struct do
            include Dry::Core::Equalizer.new(:value, :type)
          end
        end

        # @param [Nokogiri::XML::Element] element
        # @return [Dry::Monads::Result]
        def call(element)
          with_element element do
            extract_values
          end
        end
      end
    end
  end
end
