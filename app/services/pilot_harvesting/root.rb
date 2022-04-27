# frozen_string_literal: true

module PilotHarvesting
  class Root < Struct
    attribute :communities, CommunityDefinition.for_array_option
    attribute :seeds, PilotHarvesting::Types::SeedList

    def call
      with_cache do
        upsert
      end
    end

    def upsert
      retval = {}

      retval[:seeds] = seeds.map do |seed|
        yield WDPAPI::Container["seeding.import_vendored"].(seed)
      end

      retval[:communities] = yield upsert_each communities

      Success retval
    end
  end
end
