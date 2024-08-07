# frozen_string_literal: true

module System
  class CollectPgHeroSpaceStatsJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      PgHero.capture_query_stats
    end
  end
end
