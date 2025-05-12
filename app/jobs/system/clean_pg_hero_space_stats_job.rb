# frozen_string_literal: true

module System
  # @see https://github.com/ankane/pghero/blob/master/guides/Rails.md
  class CleanPgHeroSpaceStatsJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      PgHero.clean_space_stats
    end
  end
end
