# frozen_string_literal: true

Rails.application.configure do
  # Future-proofing
  config.good_job.smaller_number_is_higher_priority = true

  queues = [
    "maintenance:1",
    "+hierarchies,entities,orderings:5",
    "+extraction,harvesting,asset_fetching:5",
    "permissions,processing,default,mailers,ahoy:5",
  ].join(?;)

  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = true
  # config.good_job.on_thread_error = ->(exception) { Rollbar.error(exception) }
  config.good_job.execution_mode = :external
  config.good_job.queues = queues
  config.good_job.max_threads = 5
  config.good_job.poll_interval = 30 # seconds
  config.good_job.shutdown_timeout = 25 # seconds
  config.good_job.enable_cron = false
  config.good_job.cron = {
    "contributors.audit_contribution_counts": {
      cron: "*/5 * * * *",
      class: "Contributors::AuditContributionCountsJob",
      description: "Ensure contribution counts are up to date",
    },
    "entities.audit_authorizing": {
      cron: "*/5 * * * *",
      class: "Entities::AuditAuthorizingJob",
      description: "Audit authorizing entities",
    },
    "entities.audit_hierarchies": {
      cron: "*/5 * * * *",
      class: "Entities::AuditHierarchiesJob",
      description: "Audit authorizing entities",
    },
    "entities.audit_mismatched_schemas": {
      cron: "*/5 * * * *",
      class: "Entities::AuditMismatchedSchemasJob",
      description: "Audit mismatched schemas for entities",
    },
    "entities.populate_missing_orderings": {
      cron: "*/10 * * * *",
      class: "Entities::PopulateMissingOrderingsJob",
      description: "Populate any missing orderings on entities",
    },
    "entities.populate_visibilities": {
      cron: "*/10 * * * *",
      class: "Entities::PopulateVisibilitiesJob",
      description: "Populate entity visibilities",
    },
    "schemas.orderings.refresh_counts": {
      cron: "*/10 * * * *",
      class: "Schemas::Orderings::RefreshEntryCountsJob",
      description: "Refresh ordering entry counts",
    },
    "system.collect_pg_hero_query_stats": {
      cron: "*/5 * * * *",
      class: "System::CollectPgHeroQueryStatsJob",
      description: "Collect PGHero Query Stats",
    },
    "system.collect_pg_hero_space_stats": {
      cron: "8 * * * *",
      class: "System::CollectPgHeroSpaceStatsJob",
      description: "Collect PGHEro Space Stats",
    },
    "system.clean_pg_hero_query_stats": {
      cron: "45 22 * * 6",
      class: "System::CleanPgHeroQueryStatsJob",
      description: "Clean up PG Hero Query Stats",
    },
    "system.clean_pg_hero_space_stats": {
      cron: "45 22 * * 6",
      class: "System::CleanPgHeroSpaceStatsJob",
      description: "Clean up PG Hero Space Stats",
    }
  }

  config.good_job.dashboard_default_locale = :en
end

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  SecurityConfig.validate_basic_auth?(username, password)
end unless Rails.env.development?

GoodJob::Engine.middleware.use Rack::MethodOverride
GoodJob::Engine.middleware.use ActionDispatch::Flash
GoodJob::Engine.middleware.use ActionDispatch::Cookies
GoodJob::Engine.middleware.use ActionDispatch::Session::CookieStore
