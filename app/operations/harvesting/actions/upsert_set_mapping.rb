# frozen_string_literal: true

module Harvesting
  module Actions
    class UpsertSetMapping < Harvesting::BaseAction
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        extract_sets: "harvesting.actions.extract_sets",
        find_set: "harvesting.sources.find_set_by_identifier",
        upsert: "harvesting.mappings.upsert",
      ]

      runner do
        param :harvest_source, Harvesting::Types::Source
        param :harvest_target, Harvesting::Types::Target
        param :set_identifier, Harvesting::Types::String

        option :read_options, Harvesting::Types::Hash.optional
      end

      # @param [HarvestSource] harvest_source
      # @param [HarvestTarget] harvest_target
      # @param [String] set_identifier
      def perform(harvest_source, harvest_target, set_identifier, **options)
        yield extract_sets.call harvest_source

        set = yield find_set.call(harvest_source, set_identifier)

        mapping = yield upsert.(harvest_source, harvest_target, set: set, **options)

        Success mapping
      end
    end
  end
end
