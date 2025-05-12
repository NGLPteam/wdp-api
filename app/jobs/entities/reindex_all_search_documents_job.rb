# frozen_string_literal: true

module Entities
  # A job that runs every 10 minutes (on the 9s) to reindex the
  # {EntitySearchDocument} table.
  #
  # Individual {HierarchicalEntity} search documents are also
  # synchronized every time {Entities::Sync} runs, but this
  # ensures that the search data never grows stale.
  class ReindexAllSearchDocumentsJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      call_operation! "entities.index_search_documents"
    end
  end
end
