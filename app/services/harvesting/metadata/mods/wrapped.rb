# frozen_string_literal: true

module Harvesting
  module Metadata
    module MODS
      # A wrapper class for nested MODS metadata (i.e. from within a METS `mdWrap` tag).
      class Wrapped < Harvesting::Metadata::WrappedXMLExtractor
        add_xsi!

        add_namespace! :mods, Namespaces[:mods]

        # We need to enforce the `mods` namespace, otherwise
        # Nokogiri cannot seem to find _anything_ with
        # xpath, even with the namespace defined above.
        parse_xml_as! :document, mods: Namespaces[:mods]

        extract_values! do
          xpath :title, "(//mods:titleInfo/mods:title)[1]", type: :present_string
          xpath :abstract, "//mods:abstract", type: :string, require_match: false
          xpath :available, "//mods:dateAvailable", type: :extracted_date, require_match: false
          xpath :accessioned, "//mods:dateAccessioned", type: :extracted_date, require_match: false
          xpath :issued, "//mods:dateIssued", type: :extracted_date, require_match: false
          xpath :additional_titles, "(//mods:titleInfo/mods:title)[position() > 1]", type: :string_list, require_match: false
          xpath :genre, "//mods:genre", type: :string, require_match: false

          xpath :peer_reviewed, "//mods:recordInfoNote[@type='peer_review']", type: :bool, require_match: false do
            pipeline! do
              xml_text

              booleanize
            end
          end

          xpath_list :contributions, "//mods:name[not(ancestor::mods:name)]", type: :extracted_value_list do
            pipeline! do
              map_array do
                metadata_operation "mods.parse_contribution"

                unwrap_result!
              end

              sort_array

              uniq_array
            end
          end

          xpath :issn, "//mods:identifier[type='issn']", type: :string, require_match: false

          xpath_list :identifiers, "//mods:identifier", type: :extracted_value_map do
            pipeline! do
              map_array do
                metadata_operation "mods.parse_identifier"

                unwrap_result!
              end

              index_by :type
            end
          end

          xpath :record_identifier, "//mods:recordIdentifier/text()", type: :present_string, require_match: false
          xpath :record_identifier_source, "//mods:recordIdentifier/@source", type: :present_string, require_match: false

          # It should be this:
          # xpath :primary_collection_identifier, "//mods:recordContentSource[position() = 1]/text()", type: :present_string, require_match: false
          # xpath_list :supplementary_collection_identifiers, "//mods:recordContentSource[position() > 1]/text()", type: :string_list, require_match: false

          # But we have to post-process instead:
          xpath_list :collection_identifiers, "//mods:recordContentSource/text()", type: :string_list, require_match: false do
            pipeline! do
              map_array do
                xml_text
              end

              ucm_workaround_split!
            end
          end

          on_struct do
            include Dry::Core::Equalizer.new(:title, :record_identifier)

            # @return [Hash]
            def abstract_as_full_text
              to_full_text_reference abstract, kind: :html, lang: "en"
            end
          end
        end

        tag_section! :mods
      end
    end
  end
end
