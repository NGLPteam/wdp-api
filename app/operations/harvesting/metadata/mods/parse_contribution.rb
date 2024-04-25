# frozen_string_literal: true

module Harvesting
  module Metadata
    module MODS
      # Parse a `<mods:name />` element.
      class ParseContribution
        include Harvesting::Metadata::XMLExtraction

        add_namespace! :mods, Namespaces[:mods]

        extract_values! do
          value :name, type: :contributor_name do
            candidate do
              xpath_list ".//mods:namePart/text()" do
                pipeline! do
                  map_array do
                    xml_text
                  end

                  join_array " "
                end
              end
            end

            candidate do
              xpath ".//mods:displayForm/text()" do
                pipeline! do
                  xml_text
                end
              end
            end
          end

          xpath :identifier, ".//mods:nameIdentifier", type: :string, require_match: false

          xpath :role, ".//mods:role/mods:roleTerm/text()", type: :present_string, require_match: false

          xpath :role_type, ".//mods:role/mods:roleTerm/@type", type: :present_string, require_match: false

          xpath :name_type, ".//mods:name[@type]/@type", type: :string, require_match: false

          on_struct do
            include Comparable
            include Dry::Core::Equalizer.new(:name)

            def contributor_kind
              case name
              when ::Contributors::Types::PersonalName
                :person
              else
                :organization
              end
            end

            def contributor_attributes
              {}.tap do |h|
                h[:identifier] = identifier
              end.compact
            end

            def contributor_properties
              case contributor_kind
              when :person
                {}.tap do |h|
                  h[:given_name] = name.given
                  h[:family_name] = name.family
                  h[:appellation] = name.title.presence || name.appellation
                  h[:parsed] = name.as_json
                end
              else
                {}.tap do |h|
                  h[:legal_name] = name
                end
              end
            end

            def contribution_metadata
              {
                identifier:,
                name_type:,
                role_type:,
              }
            end

            def <=>(other)
              comp_tuple <=> other.comp_tuple
            end

            protected

            def sort_identifier
              identifier.presence || no_value
            end

            def sort_name
              case contributor_kind
              when :person
                [name.family.presence || no_value, name.given.presence || no_value]
              else
                [name, no_value]
              end
            end

            def comp_tuple
              @comp_tuple ||= [
                contributor_kind,
                sort_identifier,
                *sort_name,
              ]
            end
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
