# frozen_string_literal: true

module TestHelpers
  module JobHelpers
    module InstanceMethods
      def currently_enqueued_jobs(job: nil)
        aj_queue_adapter.enqueued_jobs.select do |j|
          job ? j[:job] == job : true
        end
      end

      def aj_queue_adapter
        ActiveJob::Base.queue_adapter
      end
    end
  end
end

RSpec.configure do |c|
  c.include TestHelpers::JobHelpers::InstanceMethods
end
