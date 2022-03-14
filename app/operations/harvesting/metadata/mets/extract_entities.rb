# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      class ExtractEntities < Harvesting::Metadata::BaseEntityExtractor
        include Dry::Effects.Resolve(:target_entity)

        include WDPAPI::Deps[
          upsert_contribution: "harvesting.metadata.mets.upsert_contribution",
        ]

        DISSERTATION_ATTRS = {
          title: "details.title",
          issn: "details.issn",
          published: "details.issued"
        }.freeze

        DISSERTATION_PROPS = {
          abstract: "details.abstract_as_full_text",
          peer_reviewed: "details.peer_reviewed",
          accessioned: "details.accessioned",
          available: "details.available",
        }.freeze

        PAPER_ATTRS = {
          title: "details.title",
          issn: "details.issn",
          published: "details.issued"
        }.freeze

        PAPER_PROPS = {
          abstract: "details.abstract_as_full_text",
          accessioned: "details.accessioned",
          available: "details.available",
        }.freeze

        MATCHES_PAPER = /\A\s*(Article|paper)\s*\z/i.freeze
        MATCHES_DISSERTATION = /\AETD|dissertation\z/i.freeze

        # @param [String] raw_metadata
        # @return [Dry::Monads::Result(void)]
        def call(raw_metadata)
          parsed = Harvesting::Metadata::METS::Parsed.new raw_metadata

          values = yield parsed.extracted_values

          root_options = options_for values

          root = yield upsert_root_from values, **root_options

          yield upsert_contributions_for root, values

          Success nil
        end

        private

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @return [{ Symbol => Object }]
        def options_for(values)
          options = {}

          case values.details.genre
          when MATCHES_PAPER
            options[:attrs] = PAPER_ATTRS
            options[:props] = PAPER_PROPS
            options[:schema] = :paper
          when MATCHES_DISSERTATION
            options[:attrs] = DISSERTATION_ATTRS
            options[:props] = DISSERTATION_PROPS
            options[:schema] = :dissertation
          else
            unsupported_metadata_kind! values.details.genre
          end

          return options
        end

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @return [Dry::Monads::Result]
        def upsert_root_from(values, attrs:, props:, schema:)
          options = {}

          options[:existing_parent] = existing_collection_from! values.parent_collection_identifier

          entity = find_or_create_entity harvest_record.identifier, **options

          with_entity.(entity) do |assigner|
            assigner.metadata_kind! values.details.genre

            assigner.attrs_and_props_from! values, attrs, props

            assigner.assets! scalar: values.scalar_assets, unassociated: values.unassociated_assets

            assigner.schema! schemas[schema]

            values.incoming_collection_identifiers.each do |id|
              assigner.link_collection! id, operator: "contains"
            end
          end
        end

        # @param [HarvestEntity] entity
        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        def upsert_contributions_for(entity, values)
          values.contributions.each do |contribution|
            yield upsert_contribution.call entity, contribution
          end

          Success nil
        end
      end
    end
  end
end
