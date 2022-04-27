# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # XML Parser for the METS metadata format
      class Parsed < Harvesting::Metadata::BaseXMLExtractor
        add_xlink!

        add_xsi!

        add_namespace! :mods, Namespaces[:mods]

        add_namespace! :premis, Namespaces[:premis]

        default_namespace! Namespaces[:mets]

        IS_MODS_SECTION = ->(o) { o.kind_of?(Harvesting::Metadata::MODS::Wrapped) }

        before_value_extraction :enforce_sections!

        memoize def administrative_metadata
          with_default_element do
            metadata_section_map "/xmlns:mets/xmlns:amdSec[descendant::xmlns:mdWrap[@MDTYPE='PREMIS']]", __method__
          end
        end

        memoize def descriptive_metadata
          with_default_element do
            metadata_section_map "/xmlns:mets/xmlns:dmdSec", __method__
          end
        end

        extract_values! do
          xpath :custodian, ".//xmlns:metsHdr/xmlns:agent[@ROLE='CUSTODIAN']/*/text()", type: :string, require_match: false

          attribute :details, :descriptive_metadata, type: :extracted_values do
            pipeline! do
              only_one! IS_MODS_SECTION, message: "One MODS mdWrap supported & expected"

              extract_values!
            end
          end

          attribute :premis_items, :administrative_metadata, type: :extracted_value_map do
            pipeline! do
              funnel_section_map_by_tags :premis

              map_array do
                extract_values!
              end

              index_by :wrapper_id
            end
          end

          xpath_list :assets, ".//xmlns:fileGrp//xmlns:file", type: :extracted_value_list do
            depends_on :premis_items

            pipeline! do
              with_mapped_dependencies do
                map_array do
                  metadata_operation "mets.parse_asset"

                  unwrap_result!
                end
              end
            end
          end

          on_struct do
            delegate :contributions, to: :details

            # @return [String]
            memoize def parent_collection_identifier
              details.primary_collection_identifier
            end

            # @return [<String>]
            memoize def incoming_collection_identifiers
              details.supplementary_collection_identifiers
            end

            memoize def pdf_version
              assets.detect(&:original_pdf?)
            end

            memoize def scalar_assets
              {
                pdf_version: pdf_version,
                text_version: text_version,
              }.compact
            end

            memoize def text_version
              assets.detect(&:text_version?)
            end

            memoize def thumbnail
              assets.detect(&:thumbnail?)
            end

            # @return [String, nil]
            memoize def thumbnail_remote_url
              thumbnail&.location&.url
            end

            memoize def unassociated_assets
              assets.select(&:unassociated?)
            end
          end
        end

        private

        # @return [void]
        def enforce_sections!
          administrative_metadata.each(&:extracted_values)

          descriptive_metadata.each(&:extracted_values)
        end

        # @param [String] query an XPath query
        # @param [#to_s] name
        # @return [Harvesting::Metadata::SectionMap]
        def metadata_section_map(query, name)
          build_section_map_from_xpath query, name, key_attribute: :wrapper_id do |element|
            build_metadata_section element
          end
        end

        # @param [Nokogiri::XML::Element] section
        # @return [Harvesting::Metadata::WrappedXMLExtractor]
        def build_metadata_section(section)
          id = section.attr("ID")

          raise "missing ID section" if id.blank?

          wrapped_metadatas = section.xpath(".//xmlns:mdWrap")

          raise "too many mdWrap in section #{id}" if wrapped_metadatas.many?

          raise "expected one mdWrap in section #{id}" if wrapped_metadatas.none?

          wrapped_metadata = wrapped_metadatas.first

          md_type = wrapped_metadata.attr("MDTYPE")

          data = wrapped_metadata.at_xpath("./*")

          case data.name
          when "xmlData"
            klass = xml_wrapper_klass_for md_type

            if klass.present?
              raw_source = data.to_xml
              inner_source = data.at_xpath("./*").to_xml

              return klass.new(raw_source, inner_source: inner_source, wrapper_id: id)
            end
          end

          # :nocov:
          raise UnsupportedMetadataWrapping.new(data: data, type: md_type, id: id)
          # :nocov:
        end

        # @param [String] md_type
        # @return [Class]
        def xml_wrapper_klass_for(md_type)
          case md_type
          when "MODS"
            Harvesting::Metadata::MODS::Wrapped
          when "PREMIS"
            Harvesting::Metadata::PREMIS::Wrapped
          end
        end
      end
    end
  end
end
