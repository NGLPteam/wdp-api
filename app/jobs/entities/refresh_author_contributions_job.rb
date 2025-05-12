# frozen_string_literal: true

module Entities
  # A periodic job run on an interval to refresh author contributions for entities,
  # prior to {Entities::ReindexAllSearchDocumentsJob}.
  #
  # @see EntityAuthorContribution
  class RefreshAuthorContributionsJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      EntityAuthorContribution.refresh!
    end
  end
end
