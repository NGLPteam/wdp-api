# frozen_string_literal: true

module Entities
  # @see Entities::PruneUnharvested
  class PruneUnharvestedJournals
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[prune_unharvested: "entities.prune_unharvested"]

    # @param [HierarchicalEntity, nil] source
    # @return [Hash]
    def call(source:)
      articles = yield prune_unharvested.call("nglp:journal_article", source:)
      issues = yield prune_unharvested.call("nglp:journal_issue", source:)
      volumes = yield prune_unharvested.call("nglp:journal_volume", source:)

      Success(articles:, issues:, volumes:)
    end
  end
end
