# frozen_string_literal: true

namespace :entities do
  desc "Reindex all entities for search asynchronously"
  task reindex_search: :environment do
    Entities::ReindexSearchJob.perform_later
  end

  desc "Rebuild all entity image derivatives"
  task reprocess_derivatives: :environment do
    Entities::ReprocessAllDerivativesJob.perform_later
  end
end
