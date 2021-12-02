# frozen_string_literal: true

module Contributors
  class RecountContributionsJob < ApplicationJob
    queue_as :maintenance

    discard_on ActiveRecord::RecordNotFound
    discard_on ActiveJob::DeserializationError

    # @return [void]
    def perform(contributor)
      call_operation! "contributors.recount_contributions", contributor
    end
  end
end
