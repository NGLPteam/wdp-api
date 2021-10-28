# frozen_string_literal: true

module TestOAI
  class Workflow
    include Dry::Monads[:do, :result]
    include MonadicPersistence
    include WDPAPI::Deps[
      scaffold_community: "test_oai.steps.scaffold_community",
      scaffold_single_collection: "test_oai.steps.scaffold_single_collection",
      scaffold_source: "test_oai.steps.scaffold_source",
      maybe_extract_sets: "test_oai.steps.maybe_extract_sets",
      scaffold_collections_and_mappings: "test_oai.steps.scaffold_collections_and_mappings",
      run_harvest_mappings: "test_oai.steps.run_harvest_mappings",
      manually_run_source: "harvesting.actions.manually_run_source",
    ]

    def call(community_options: {}, source_options: {}, single_collection: {}, set_identifiers: [])
      community = yield scaffold_community.call(**community_options)

      source = yield scaffold_source.call(**source_options)

      yield maybe_extract_sets.call(source)

      if set_identifiers.present?
        yield scaffold_collections_and_mappings.call(community, source, *set_identifiers)

        yield run_harvest_mappings.call source
      else
        collection = yield scaffold_single_collection.call(community, single_collection)

        yield manually_run_source.call source, collection
      end

      Success nil
    end
  end
end
