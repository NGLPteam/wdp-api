# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Metadata parser for the JATS metadata format
      class Parsed < Harvesting::Metadata::BaseXMLExtractor
        add_xlink!

        add_xsi!

        default_namespace! Namespaces[:jats]

        extract_values! do
          xpath :doi, %{.//xmlns:article-id[@pub-id-type="doi"]/text()}, type: :string, require_match: false

          xpath :publisher_id, %{.//xmlns:article-id[@pub-id-type="publisher-id"]/text()}, type: :string, require_match: false

          value :article_identifier, type: :present_string, require_match: false do
            from_value :doi
            from_value :publisher_id
          end

          xpath :summary, %{.//xmlns:abstract}, type: :string, require_match: false

          compose_value :abstract, from: :summary, type: :full_text, require_match: false do
            pipeline! do
              full_text_plain
            end
          end

          xpath_list :body, "/xmlns:article/xmlns:body/*", type: :full_text, require_match: false do
            pipeline! do
              xml_to_html

              full_text_html
            end
          end

          xpath :date_collected, %,.//xmlns:pub-date[@date-type="collection"],, type: :variable_precision_date, require_match: false do
            pipeline! do
              metadata_operation "jats.parse_pub_date"
            end
          end

          xpath :epub_published, %,.//xmlns:pub-date[@date-type="pub"][@publication-format="epub"],, type: :variable_precision_date, require_match: false do
            pipeline! do
              metadata_operation "jats.parse_pub_date"
            end
          end

          xpath :published, %,.//xmlns:pub-date[@date-type="pub"],, type: :variable_precision_date, require_match: false do
            pipeline! do
              metadata_operation "jats.parse_pub_date"
            end
          end

          value :title, type: :present_string do
            xpath %,.//xmlns:title-group/xmlns:article-title/text(),
            xpath %,.//xmlns:title-group/xmlns:trans-title-group[@xml:lang="en"]/xmlns:trans-title/text(),
            xpath %,.//xmlns:title-group/xmlns:trans-title-group/xmlns:trans-title/text(),
          end

          xpath :fpage, %,.//xmlns:fpage/text(),, type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          xpath :lpage, %,.//xmlns:lpage/text(),, type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          xpath :page_count, %,.//xmlns:counts/xmlns:page-count/@count,, type: :integer, require_match: false do
            pipeline! do
              xml_text
            end
          end

          xpath :online_url, %,.//xmlns:self-uri[not(@content-type="application/pdf")]/@xlink:href,, type: :url, require_match: false

          xpath :pdf_url, %,.//xmlns:self-uri[@content-type="application/pdf"]/@xlink:href,, type: :url, require_match: false

          xpath_list :organization_contributions, ".//xmlns:aff", type: :contributions, require_match: false do
            pipeline! do
              map_array do
                metadata_operation "jats.parse_organization_contribution"

                unwrap_result!
              end

              compact
            end
          end

          xpath_list :person_contributions, ".//xmlns:contrib-group/xmlns:contrib", type: :contributions, require_match: false do
            pipeline! do
              map_array do
                metadata_operation "jats.parse_person_contribution"

                unwrap_result!
              end

              compact
            end
          end

          on_struct do
            def has_issue?
              issue.present? && issue.valid?
            end

            def has_volume?
              volume.present? && volume.valid?
            end

            def online_version
              return if online_url.blank?

              {
                label: title,
                href: online_url,
              }
            end

            # @return [<Hash>]
            memoize def contributions
              Array(organization_contributions) + Array(person_contributions)
            end
          end

          set :issue do
            xpath :id, %,.//xmlns:issue-id/text(),, type: :present_string, require_match: false

            xpath :number, %,.//xmlns:issue/text(),, type: :present_string

            compose_value :identifier, from: "issue.number", type: :present_string do
              pipeline! do
                maybe_prefix "issue-"
              end
            end

            value :sortable_number, type: :integer do
              from_value "issue.number" do
                pipeline! do
                  metadata_operation "jats.parse_sortable_number"
                end
              end
            end

            value :title, type: :present_string do
              xpath %,.//xmlns:issue-title/text(),

              from_value "issue.number" do
                pipeline! do
                  maybe_prefix "Issue "
                end
              end
            end

            on_struct do
              validates :number, :title, :identifier, presence: true
            end
          end

          set :volume do
            xpath :id, %,.//xmlns:volume/text(),, type: :present_string

            compose_value :number, from: "volume.id", type: :present_string

            compose_value :identifier, from: "volume.id", type: :present_string do
              pipeline! do
                maybe_prefix "volume-"
              end
            end

            xpath :sequence, %,.//xmlns:volume/@seq,, type: :present_string, require_match: false

            compose_value :sequence_number, from: "volume.sequence", type: :integer, require_match: false

            value :sortable_number, type: :integer do
              from_value "volume.sequence_number"

              from_value "volume.id"
            end

            compose_value :title, from: "volume.id", type: :present_string do
              pipeline! do
                maybe_prefix "Volume "
              end
            end

            on_struct do
              validates :title, :id, :identifier, presence: true
            end
          end
        end
      end
    end
  end
end
