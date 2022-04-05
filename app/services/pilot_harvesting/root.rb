# frozen_string_literal: true

module PilotHarvesting
  class Root < Struct
    attribute :communities, (Types::Array.of(CommunityDefinition).default { [] })

    def call
      retval = {}

      retval[:communities] = communities.map do |community|
        community.upsert.value!
      end

      Success retval
    end
  end
end
