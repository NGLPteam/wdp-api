# frozen_string_literal: true

module System
  # @see https://github.com/ankane/pghero/blob/master/guides/Rails.md
  class CleanPgHeroQueryStatsJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      PgHero.clean_query_stats
    end
  end
end
