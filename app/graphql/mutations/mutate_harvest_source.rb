# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::CreateHarvestSource
  # @see Mutations::UpdateHarvestSource
  class MutateHarvestSource < Mutations::BaseMutation
    include Mutations::Shared::AcceptsHarvestExtractionMappingTemplate
    include Mutations::Shared::AcceptsHarvestOptions

    description <<~TEXT
    A base mutation that is used to share fields between `createHarvestSource` and `updateHarvestSource`.
    TEXT

    field :harvest_source, Types::HarvestSourceType, null: true do
      description <<~TEXT
      The newly-modified harvest source, if successful.
      TEXT
    end

    argument :name, String, required: true do
      description <<~TEXT
      A unique name for the source. Purely descriptive.
      TEXT
    end

    argument :base_url, String, required: true do
      description <<~TEXT
      The URL to fetch from. It should be just the base URL, without any OAI verbs or similar.
      TEXT
    end

    argument :description, String, required: false do
      description <<~TEXT
      An optional, wordier description for the source that may offer insight as to its intended
      purpose within the installation.
      TEXT
    end
  end
end
