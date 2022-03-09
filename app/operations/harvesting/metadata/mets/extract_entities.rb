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
          accessioned: "details.accessioned",
          available: "details.available",
          issued: "details.issued",
        }.freeze

        DISSERTATION_PROPS = {
          abstract: "details.abstract_as_full_text",
          peer_reviewed: "details.peer_reviewed",
          accessioned: "details.accessioned",
          available: "details.available",
          issued: "details.issued",
        }.freeze

        # @param [String] raw_metadata
        # @return [Dry::Monads::Result(void)]
        def call(raw_metadata)
          parsed = Harvesting::Metadata::METS::Parsed.new raw_metadata

          values = yield parsed.extracted_values

          dissertation = yield upsert_dissertation_from values

          yield upsert_contributions_for dissertation, values

          Success nil
        end

        private

        # @param [Harvesting::Metadata::ValueExtraction::Struct] values
        # @return [Dry::Monads::Result]
        def upsert_dissertation_from(values)
          options = {}

          options[:existing_parent] = existing_collection_from! values.parent_collection_identifier

          dissertation = find_or_create_entity harvest_record.identifier, **options

          with_entity.(dissertation) do |assigner|
            assigner.metadata_kind! values.details.genre

            assigner.attrs_and_props_from! values, DISSERTATION_ATTRS, DISSERTATION_PROPS

            assigner.assets! scalar: values.scalar_assets, unassociated: values.unassociated_assets

            assigner.schema! schemas[:dissertation]

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
