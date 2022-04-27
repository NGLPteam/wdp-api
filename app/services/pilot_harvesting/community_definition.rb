# frozen_string_literal: true

module PilotHarvesting
  class CommunityDefinition < Struct
    include PilotHarvesting::Harvestable

    attribute :identifier, Types::String

    attribute :title, Types::String

    attribute :journals, PilotHarvesting::JournalDefinition.for_array_option

    attribute :series, PilotHarvesting::SeriesDefinition.for_array_option

    def upsert
      call_operation("communities.upsert", identifier, title: title) do |community|
        provide community: community do
          yield upsert_each journals
          yield upsert_each series
        end

        yield upsert_source_for! community

        Success community
      end
    end
  end
end
