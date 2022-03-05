# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Metadata parser for the JATS metadata format
      class Parsed < Harvesting::Metadata::BaseXMLExtractor
        # Some issue numbers are things like `2/3`. We'll parse them as 2 for sorting purposes.
        ODDLY_FORMATTED_ISSUE_NUMBER = %r,\A(\d+)/\d+\z,.freeze

        # @!attribute [r] front
        # @return [Nokogiri::XML::Element, nil]
        memoize def front
          root.at_xpath("/xmlns:article/xmlns:front")
        end

        # @!attribute [r] article_meta
        # @return [Nokogiri::XML::Element, nil]
        memoize def article_meta
          root.at_xpath("/xmlns:article/xmlns:front/xmlns:article-meta")
        end

        def has_article_identifier?
          identifier.present?
        end

        memoize def body
          content = root.xpath("/xmlns:article/xmlns:body/*")&.to_html

          return if content.blank?

          {
            content: content,
            lang: "en",
            kind: "html"
          }
        end

        memoize def doi
          text_from from_article_meta(%,./xmlns:article-id[@pub-id-type="doi"]/text(),)
        end

        memoize def article_identifier
          doi.presence || publisher_id.presence
        end

        memoize def publisher_id
          text_from from_article_meta(%,./xmlns:article-id[@pub-id-type="publisher-id"]/text(),)
        end

        # @return [VariablePrecisionDate]
        memoize def date_collected
          parse_variable_pubdate from_article_meta(%,./xmlns:pub-date[@date-type="collection"],)
        end

        # @return [VariablePrecisionDate]
        memoize def epub_published
          parse_variable_pubdate from_article_meta(%,./xmlns:pub-date[@date-type="pub"][@publication-format="epub"],)
        end

        # @return [VariablePrecisionDate]
        memoize def published
          parse_variable_pubdate from_article_meta(%,./xmlns:pub-date[@date-type="pub"],)
        end

        # @return [String]
        memoize def summary
          text_from from_article_meta(%,./xmlns:abstract,), fallback: ""
        end

        memoize def abstract
          return if summary.blank?

          {
            content: summary,
            lang: "en",
            kind: "text",
          }
        end

        TITLE_CANDIDATES = [
          %,./xmlns:title-group/xmlns:article-title/text(),,
          %,./xmlns:title-group/xmlns:trans-title-group[@xml:lang="en"]/xmlns:trans-title/text(),,
          %,./xmlns:title-group/xmlns:trans-title-group/xmlns:trans-title/text(),
        ].freeze

        # @return [String]
        memoize def title
          find_candidate_text_for(article_meta, TITLE_CANDIDATES, fallback: "Unknown Article Title")
        end

        memoize def fpage
          int_from from_article_meta(%,./xmlns:fpage/text(),)
        end

        memoize def lpage
          int_from from_article_meta(%,./xmlns:lpage/text(),)
        end

        memoize def page_count
          int_from from_article_meta(%,./xmlns:counts/xmlns:page-count/@count,)
        end

        # @return [String, nil]
        memoize def online_url
          text_from from_article_meta(%,./xmlns:self-uri[not(@content-type)]/@xlink:href,)
        end

        memoize def online_version
          return if online_url.blank?

          {
            label: title,
            href: online_url,
          }
        end

        memoize def pdf_url
          text_from from_article_meta(%,./xmlns:self-uri[@content-type="application/pdf"]/@xlink:href,)
        end

        # @!group Issue Attributes

        def has_issue?
          issue_id.present?
        end

        # @return [String]
        memoize def issue_id
          text_from from_article_meta(%,./xmlns:issue-id/text(),)
        end

        # @return [String]
        memoize def issue_number
          text_from from_article_meta(%,./xmlns:issue/text(),)
        end

        # @note This is a place for improvement. Issue IDs are not guaranteed to be integral.
        #   They could be roman numerals, alphanumeric, etc.
        # @return [Integer, nil]
        memoize def issue_sortable_number
          return issue_id.to_i if looks_like_integer?(issue_id)

          # :nocov:
          case issue_number
          when ODDLY_FORMATTED_ISSUE_NUMBER
            Regexp.last_match[1].to_i
          when LOOKS_LIKE_INTEGER
            issue_number.to_i
          end
          # :nocov:
        end

        # @return [String]
        memoize def issue_identifier
          "issue-#{issue_id}" if has_issue?
        end

        # @return [String]
        memoize def issue_title
          return unless has_issue?

          text_from from_article_meta(%,./xmlns:issue-title/text(),), fallback: "Issue #{issue_number.presence || issue_id}"
        end

        # @!endgroup

        # @!group Volume Attributes

        def has_volume?
          volume_id.present?
        end

        memoize def volume_identifier
          return unless has_volume?

          "volume-#{volume_id}"
        end

        # @note This is a place for improvement. Volume IDs are not guaranteed to be integral.
        #   They could be roman numerals, alphanumeric, etc.
        memoize def volume_sortable_number
          volume_id&.to_i
        end

        memoize def volume_title
          return unless has_volume?

          "Volume #{volume_id}"
        end

        memoize def volume_id
          text_from from_article_meta(%,./xmlns:volume/text(),)
        end

        alias volume_number volume_id

        memoize def volume_sequence
          text_from from_article_meta(%,./xmlns:volume/@seq,)
        end

        # @note Like {#volume_sortable_number}, these values are not guaranteed to be integral.
        memoize def volume_sequence_number
          volume_sequence&.to_i
        end

        # @!endgroup

        # @!group Contributions

        memoize def contributions
          affiliated_organization_contributions + person_contributions
        end

        memoize def affiliated_organization_contributions
          value = all_from_article_meta("./xmlns:aff")&.map do |aff|
            generate_affiliated_organization_contribution_from aff
          end

          Array(value).compact
        end

        memoize def person_contributions
          value = all_from_article_meta("./xmlns:contrib-group/xmlns:contrib")&.map do |contrib|
            generate_person_contribution_from contrib
          end

          Array(value).compact
        end

        # @!endgroup

        # @!group Utility methods

        # @param [String] rid
        # @return [String, nil]
        def aff_for(rid)
          return if rid.blank?

          text_from from_article_meta(%,./xmlns:aff[@id="#{rid}"]/xmlns:institution/text(),)
        end

        def all_from_article_meta(xpath)
          all_from article_meta, xpath
        end

        # @api private
        def from_article_meta(xpath)
          from article_meta, xpath
        end

        def generate_affiliated_organization_contribution_from(aff)
          legal_name = text_from aff.at_xpath("./xmlns:institution/text()")

          return if legal_name.blank?

          contributor = {
            kind: :organization,
            attributes: {},
            properties: {
              legal_name: legal_name
            }
          }

          {
            kind: "affiliated_institution",
            metadata: {
              "aff_id" => aff.attr("id"),
            },
            contributor: contributor
          }
        end

        # @param [Nokogiri::XML::Element] contrib
        # @return [Hash, nil]
        def generate_person_contribution_from(contrib)
          contributor = generate_person_contributor_from contrib

          return if contributor.blank?

          kind = contribution_role_from contrib

          metadata = {
            "corresp" => (contrib.at_xpath("./@corresp")&.text == "yes")
          }

          {
            kind: kind,
            metadata: metadata,
            contributor: contributor,
          }
        end

        CONTRIB_ROLE_CANDIDATE_PATHS = [
          "./@contrib-type",
          "./xmlns:role/text()",
          "./parent::xmlns:contrib-group/@content-type"
        ].freeze

        # @param [Nokogiri::XML::Element] contrib
        def contribution_role_from(contrib)
          find_candidate_text_for contrib, CONTRIB_ROLE_CANDIDATE_PATHS
        end

        # @param [Nokogiri::XML::Element] contrib
        def generate_person_contributor_from(contrib)
          rid = contrib.at_xpath(%,./xmlns:xref[@ref-type="aff"][@rid]/@rid,)&.text

          affiliation = aff_for rid

          given_name = text_from(contrib.xpath("./xmlns:name/xmlns:given-names/text()"))

          family_name = text_from(contrib.at_xpath("./xmlns:name/xmlns:surname/text()"))

          # We should handle this better with potential other naming styles in JATS
          return if given_name.blank? || family_name.blank?

          {
            kind: :person,
            attributes: {
              email: text_from(contrib.at_xpath("./xmlns:email/text()")),
            },
            properties: {
              given_name: given_name,
              family_name: family_name,
              affiliation: affiliation,
            }
          }
        end

        # @api private
        # @param [Nokogiri::XML::Element] element
        # @return [VariablePrecisionDate]
        def parse_variable_pubdate(element)
          return VariablePrecisionDate.none unless element&.name == "pub-date"

          year = int_from element.at_xpath("./xmlns:year/text()")
          month = int_from element.at_xpath("./xmlns:month/text()")
          day = int_from element.at_xpath("./xmlns:day/text()")

          return VariablePrecisionDate.none if year.blank?

          serialized =
            if day.present? && month.present?
              "(%04d-%02d-%02d,day)" % [year, month, day]
            elsif month.present?
              "(%04d-%02d-01,month)" % [year, month]
            else
              "(%04d-01-01,year)" % [year]
            end

          VariablePrecisionDate.parse serialized
        rescue ArgumentError
          VariablePrecisionDate.none
        end

        # @!endgroup
      end
    end
  end
end
