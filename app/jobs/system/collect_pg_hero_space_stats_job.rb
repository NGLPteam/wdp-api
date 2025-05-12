# frozen_string_literal: true

module System
  class CollectPgHeroSpaceStatsJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      PgHero.capture_query_stats
    end
  end
end
