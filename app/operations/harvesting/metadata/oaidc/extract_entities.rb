# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class ExtractEntities < Harvesting::Metadata::BaseEntityExtractor
        include Dry::Effects.Resolve(:target_entity)

        # @param [String] raw_metadata
        # @return [Dry::Monads::Result(void)]
        def call(raw_metadata)
          values = yield metadata_format.extract_values raw_metadata

          child = yield handle_by_parent values

          yield upsert_contribution_proxies.(child, values.authors)

          Success nil
        end

        private

        # @param [Harvesting::Metadata::OAIDC::Parsed::ExtractedValues] values
        # @return [Dry::Monads::Success(HarvestEntity)]
        def handle_by_parent(values)
          declaration = target_entity.schema_version.declaration

          case declaration
          when /\Anglp:journal:/
            handle_journal values
          when /\Anglp:series:/
            handle_series values
          else
            # :nocov:
            Failure[:unsupported_target, "Don't know how to upsert OAIDC metadata on #{declaration}"]
          end
        end

        # @param [Harvesting::Metadata::OAIDC::Parsed::ExtractedValues] values
        # @return [Dry::Monads::Success(HarvestEntity)]
        def handle_journal(values)
          skip_record! "article is missing volume or issue" unless values.has_journal?

          volume = yield upsert_volume_from values

          issue = yield upsert_issue_from values, volume: volume

          upsert_article_from values, issue: issue
        end

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
          doi: "issue.doi",
          title: "issue.title",
        }.freeze

        ISSUE_PROPS = {
          "volume.id" => "volume.id",
          "volume.sortable_number" => "volume.sortable_number",
          "number" => "issue.number",
          "id" => "issue.id",
          "sortable_number" => "issue.sortable_number",
        }.freeze

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @param [HarvestEntity] volume
        # @return [HarvestEntity]
        def upsert_issue_from(values, volume:)
          identifier = values.issue.doi.presence || values.issue.identifier

          issue = find_or_create_entity identifier, parent: volume

          with_entity.(issue) do |assigner|
            assigner.metadata_kind! "issue"

            assigner.attrs_and_props_from! values, ISSUE_ATTRS, ISSUE_PROPS

            assigner.schema! schemas[:issue]
          end
        end

        ARTICLE_ATTRS = {
          summary: "summary",
          title: "title",
          published: "published",
          doi: "doi",
        }.freeze

        ARTICLE_PROPS = {
          abstract: "summary",
          keywords: "keywords",
          online_version: "online_version",
          "volume.id" => "volume.id",
          "volume.sortable_number" => "volume.sortable_number",
          "issue.title" => "issue.title",
          "issue.number" => "issue.number",
          "issue.sortable_number" => "issue.sortable_number",
          "issue.id" => "issue.id",
          "issue.fpage" => "journal.fpage",
          "issue.lpage" => "journal.lpage",
          "meta.published" => "published",
        }.freeze

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @param [HarvestEntity] issue
        def upsert_article_from(values, issue:)
          identifier = harvest_record.identifier

          article = find_or_create_entity identifier, parent: issue

          with_entity.(article) do |assigner|
            assigner.metadata_kind! "article"

            assigner.attrs_and_props_from! values, ARTICLE_ATTRS, ARTICLE_PROPS

            assigner.assets! scalar: values.scalar_assets, unassociated: values.unassociated_assets

            assigner.schema! schemas[:article]
          end
        end

        # @param [Harvesting::Metadata::OAIDC::Parsed::ExtractedValues] values
        # @return [Dry::Monads::Success(HarvestEntity)]
        def handle_series(values)
          upsert_paper_from values
        end

        PAPER_ATTRS = {
          doi: "doi",
          title: "title",
          summary: "summary",
          issn: "issn",
          published: "published",
        }.freeze

        PAPER_PROPS = {
          abstract: "summary",
        }.freeze

        # @param [Harvesting::Metadata::OAIDC::Parsed::ExtractedValues] values
        # @return [Dry::Monads::Success(HarvestEntity)]
        def upsert_paper_from(values)
          identifier = harvest_record.identifier

          paper = find_or_create_entity identifier

          with_entity.(paper) do |assigner|
            assigner.metadata_kind! "paper"

            assigner.attrs_and_props_from! values, PAPER_ATTRS, PAPER_PROPS

            assigner.assets! scalar: values.scalar_assets, unassociated: values.unassociated_assets

            assigner.schema! schemas[:paper]
          end
        end
      end
    end
  end
end
