# frozen_string_literal: true

module System
  # Vacuum the database
  class VacuumFullJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      ApplicationRecord.connection_pool.with_connection do |c|
        c.execute %[VACUUM FULL ANALYZE]
      end
    end
  end
end
