# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ExtractEntities < Harvesting::Metadata::BaseEntityExtractor
        include WDPAPI::Deps[
          upsert_contribution: "harvesting.metadata.jats.upsert_contribution",
        ]

        # @param [String] raw_metadata
        # @return [Dry::Monads::Result(void)]
        def call(raw_metadata)
          parsed = Harvesting::Metadata::JATS::Parsed.new raw_metadata

          return Success(nil) unless parsed.has_volume? && parsed.has_issue?

          volume = yield upsert_volume_from parsed

          issue = yield upsert_issue_from parsed, volume: volume

          article = yield upsert_article_from parsed, issue: issue

          yield upsert_contributions_for article, parsed

          Success nil
        end

        private

        def upsert_volume_from(parsed)
          identifier = parsed.volume_identifier

          volume = find_or_create_entity identifier

          with_entity.(volume) do |assigner|
            assigner.metadata_kind! "volume"

            assigner.attr! :title, parsed.volume_title

            assigner.prop! "id", parsed.volume_id
            assigner.prop! "seq", parsed.volume_sequence

            assigner.schema! schemas[:volume]
          end
        end

        def upsert_issue_from(parsed, volume:)
          identifier = parsed.issue_identifier

          issue = find_or_create_entity identifier, parent: volume

          with_entity.(issue) do |assigner|
            assigner.metadata_kind! "issue"

            assigner.attr! :title, parsed.issue_title

            assigner.prop! "number", parsed.issue_number
            assigner.prop! "id", parsed.issue_id

            assigner.schema! schemas[:issue]
          end
        end

        def upsert_article_from(parsed, issue:)
          identifier = parsed.article_identifier

          article = find_or_create_entity identifier, parent: issue

          with_entity.(article) do |assigner|
            assigner.metadata_kind! "article"

            assigner.attr! :title, parsed.title
            assigner.attr! :published, parsed.published
            assigner.attr! :doi, parsed.doi
            assigner.attr! :summary, parsed.summary

            assigner.prop! "body", parsed.body

            assigner.prop! "dates.collected", parsed.date_collected
            assigner.prop! "epub.published", parsed.epub_published

            assigner.prop! "volume.number", parsed.volume_id
            assigner.prop! "volume.sequence", parsed.volume_sequence

            assigner.prop! "online_version", parsed.online_version

            if parsed.pdf_url.present?
              assigner.scalar_asset!(
                "pdf.version", "pdf", parsed.pdf_url,
                name: "PDF Version", mime_type: "application/pdf"
              )
            end

            assigner.prop! "issue.title", parsed.issue_title
            assigner.prop! "issue.number", parsed.issue_number
            assigner.prop! "issue.id", parsed.issue_id
            assigner.prop! "issue.fpage", parsed.fpage
            assigner.prop! "issue.lpage", parsed.lpage

            assigner.prop! "page_count", parsed.page_count

            assigner.schema! schemas[:article]
          end
        end

        def upsert_contributions_for(article, parsed)
          parsed.contributions.each do |contribution|
            yield upsert_contribution.call article, contribution
          end

          Success nil
        end
      end
    end
  end
end
