# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # XML Parser for the OAIDC metadata format
      class Parsed < Harvesting::Metadata::BaseXMLExtractor
        add_xlink!

        add_xsi!

        add_namespace! :oai_dc, Namespaces[:oaidc]

        add_namespace! :dc, Namespaces[:dc]

        default_namespace! Namespaces[:oaidc]

        HTTP_URL = AppTypes::String.constrained(http_uri: true)

        extract_values! do
          xpath :title, ".//dc:title", type: :string, require_match: true
          xpath :published, ".//dc:date", type: :extracted_date, require_match: true
          xpath :publisher, ".//dc:publisher", type: :contribution_proxy, require_match: false do
            pipeline! do
              xml_text

              parse_organization_contribution kind: "publisher"
            end
          end

          xpath :summary, ".//dc:description", type: :string, require_match: false

          xpath_list :authors, ".//dc:creator", type: :contribution_proxies, require_match: false do
            pipeline! do
              map_array do
                xml_text
              end

              parse_people_contributions kind: "author"

              compact
            end
          end

          xpath_list :keywords, ".//dc:subject", type: :string_list, require_match: false do
            pipeline! do
              map_array do
                xml_text
              end

              metadata_operation "oaidc.split_keywords"
            end
          end

          xpath_list :identifiers, ".//dc:identifier", type: :string_list, require_match: true
          xpath_list :sources, ".//dc:source", type: :string_list, require_match: true
          xpath_list :types, ".//dc:type", type: :string_list, require_match: false

          xpath_list :asset_formats, ".//dc:format", type: :string_list, require_match: false
          xpath_list :asset_urls, ".//dc:relation", type: :string_list, require_match: false

          compose_value :doi, from: :identifiers, type: AppTypes::DOI, require_match: false do
            pipeline! do
              first_conforming_to AppTypes::DOI
            end
          end

          compose_value :online_url, from: :identifiers, type: :string, require_match: false do
            pipeline! do
              first_conforming_to HTTP_URL
            end
          end

          compose_value :issn, from: :sources, type: AppTypes::ISSN, require_match: false do
            pipeline! do
              first_conforming_to AppTypes::ISSN
            end
          end

          compose_value :issue_doi, from: :sources, type: AppTypes::DOI, require_match: false do
            pipeline! do
              first_conforming_to AppTypes::DOI
            end
          end

          value :journal, type: :journal_source, require_match: false do
            xpath ?., type: :journal_source do
              pipeline! do
                metadata_operation "oaidc.extract_journal_source"
              end
            end

            from_value :sources, type: :journal_source do
              parse_journal_source!
            end
          end

          on_struct do
            memoize def assets
              actual_urls = asset_urls.select { |url| HTTP_URL.valid? url }

              formats = asset_formats.take(actual_urls.size)

              if formats.one? && formats.size < actual_urls.size
                formats *= actual_urls.size
              else
                # This maybe should be treated as an error
                actual_urls = actual_urls.take(formats.size)
              end

              formats << formats.last until formats.size >= actual_urls.size

              zipped = actual_urls.zip formats

              zipped.map.with_index do |(url, format), index|
                position = index + 1

                Harvesting::Metadata::OAIDC::AssetProxy.new url, format, position: position
              end
            end

            def has_journal?
              (journal.present? && journal.known?) || (volume.present? && issue.present?)
            end

            memoize def online_version
              return if online_url.blank?

              {
                label: title,
                href: online_url,
              }
            end

            memoize def pdf_version
              assets.detect(&:pdf?)
            end

            memoize def scalar_assets
              {
                pdf_version: pdf_version,
              }.compact
            end

            memoize def unassociated_assets
              assets.select(&:unassociated?)
            end
          end

          set :volume do
            journal_source_volume_attrs! from: :journal, xpath_query: ".//dc:volume"

            compose_value :issn, from: :sources, type: AppTypes::ISSN, require_match: false do
              pipeline! do
                first_conforming_to AppTypes::ISSN
              end
            end
          end

          set :issue do
            journal_source_issue_attrs! from: :journal, xpath_query: ".//dc:issue"

            compose_value :issn, from: :sources, type: AppTypes::ISSN, require_match: false do
              pipeline! do
                first_conforming_to AppTypes::ISSN
              end
            end

            compose_value :doi, from: :sources, type: AppTypes::DOI, require_match: false do
              pipeline! do
                first_conforming_to AppTypes::DOI
              end
            end
          end
        end
      end
    end
  end
end
