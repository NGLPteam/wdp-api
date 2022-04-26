# frozen_string_literal: true

module Seeding
  module Import
    class UpsertCommunities
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        upsert_community: "seeding.import.upsert_community",
      ]

      # @param [Seeding::Import::Structs::Import] import
      # @return [Dry::Monads::Success<Community>]
      def call(import)
        communities = import.communities.map do |source|
          yield upsert_community.(source)
        end

        Success communities
      end
    end
  end
end
