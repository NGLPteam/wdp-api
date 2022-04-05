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

          values = yield parsed.extracted_values

          return Success(nil) unless values.has_volume? && values.has_issue?

          volume = yield upsert_volume_from values

          issue = yield upsert_issue_from values, volume: volume

          article = yield upsert_article_from values, issue: issue

          yield upsert_contributions_for article, values

          Success nil
        end

        private

        VOLUME_ATTRS = {
          title: "volume.title",
        }.freeze

        VOLUME_PROPS = {
          id: "volume.id",
          sortable_number: "volume.sortable_number",
        }.freeze

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @return [HarvestEntity]
        def upsert_volume_from(values)
          identifier = values.volume.identifier

          volume = find_or_create_entity identifier

          with_entity.(volume) do |assigner|
            assigner.metadata_kind! "volume"

            assigner.attrs_and_props_from! values, VOLUME_ATTRS, VOLUME_PROPS

            assigner.schema! schemas[:volume]
          end
        end

        ISSUE_ATTRS = {
          title: "issue.title",
        }.freeze

        ISSUE_PROPS = {
          "volume.id" => "volume.id",
          "volume.sortable_number" => "volume.sortable_number",
          "volume.sequence" => "volume.sequence_number",
          "number" => "issue.number",
          "id" => "issue.id",
          "sortable_number" => "issue.sortable_number",
        }.freeze

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @param [HarvestEntity] volume
        # @return [HarvestEntity]
        def upsert_issue_from(values, volume:)
          identifier = values.issue.identifier

          issue = find_or_create_entity identifier, parent: volume

          with_entity.(issue) do |assigner|
            assigner.metadata_kind! "issue"

            assigner.attrs_and_props_from! values, ISSUE_ATTRS, ISSUE_PROPS

            assigner.schema! schemas[:issue]
          end
        end

        ARTICLE_ATTRS = {
          title: "title",
          published: "published",
          doi: "doi",
          summary: "summary",
        }.freeze

        ARTICLE_PROPS = {
          body: "body",
          abstract: "abstract",
          online_version: "online_version",
          "volume.id" => "volume.id",
          "volume.sortable_number" => "volume.sortable_number",
          "volume.sequence" => "volume.sequence_number",
          "issue.title" => "issue.title",
          "issue.number" => "issue.number",
          "issue.sortable_number" => "issue.sortable_number",
          "issue.id" => "issue.id",
          "issue.fpage" => "fpage",
          "issue.lpage" => "lpage",
          "meta.collected" => "date_collected",
          "meta.published" => "epub_published",
          "meta.page_count" => "page_count",
        }.freeze

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @param [HarvestEntity] issue
        def upsert_article_from(values, issue:)
          identifier = harvest_record.identifier

          article = find_or_create_entity identifier, parent: issue

          with_entity.(article) do |assigner|
            assigner.metadata_kind! "article"

            assigner.attrs_and_props_from! values, ARTICLE_ATTRS, ARTICLE_PROPS

            if values.pdf_url.present?
              assigner.scalar_asset!(
                "pdf_version", "pdf", values.pdf_url,
                name: "PDF Version", mime_type: "application/pdf"
              )
            end

            assigner.schema! schemas[:article]
          end
        end

        # @param [HarvestEntity] article
        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        def upsert_contributions_for(article, values)
          values.contributions.each do |contribution|
            yield upsert_contribution.call article, contribution.deep_symbolize_keys
          end

          Success nil
        end
      end
    end
  end
end
