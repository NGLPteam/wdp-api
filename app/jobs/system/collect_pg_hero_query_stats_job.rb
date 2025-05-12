# frozen_string_literal: true

module System
  # @see https://github.com/ankane/pghero/blob/master/guides/Rails.md
  class CollectPgHeroQueryStatsJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      PgHero.capture_query_stats
    end
  end
end
