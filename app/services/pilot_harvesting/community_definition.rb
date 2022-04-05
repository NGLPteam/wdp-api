# frozen_string_literal: true

module PilotHarvesting
  class CommunityDefinition < Struct
    attribute :identifier, Types::String

    attribute :title, Types::String

    attribute :journals, (Types::Array.of(PilotHarvesting::JournalDefinition).default { [] })

    def upsert
      call_operation("communities.upsert", identifier, title: title) do |community|
        provide community: community, default_collection_schema: SchemaVersion["nglp:journal"] do
          journals.each do |journal|
            journal.upsert.value!
          end
        end

        Success community
      end
    end
  end
end
