# frozen_string_literal: true

Zhong.redis = Redis.new(
  url: ENV["REDIS_URL"],
  db: 1,
  driver: :ruby,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
)

Zhong.schedule do
  category "contributors" do
    every 5.minutes, "audit_contribution_counts" do
      Contributors::AuditContributionCountsJob.perform_later
    end
  end

  category "entities" do
    every 5.minutes, "audit_authorizing" do
      Entities::AuditAuthorizingJob.perform_later
    end

    every 10.minutes, "populate_missing_orderings" do
      Entities::PopulateMissingOrderingsJob.perform_later
    end

    every 10.minutes, "populate_visibilities" do
      Entities::PopulateVisibilitiesJob.perform_later
    end
  end

  category "orderings" do
    every 10.minutes, "refresh_counts" do
      Schemas::Orderings::RefreshEntryCountsJob.perform_later
    end
  end
end
