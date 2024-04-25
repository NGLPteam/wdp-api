# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch

  groups.delete "Channels"
  groups.delete "Helpers"
  groups.delete "Libraries"
  groups.delete "Mailers"

  add_group "GraphQL", "app/graphql"
  add_group "Harvesting", [
    %r|app/models/harvest|,
    %r|app/models/concerns/[^/]*harvest|,
    "app/operations/harvesting",
    "app/services/harvesting",
  ]
  add_group "Operations", "app/operations"
  add_group "Policies", "app/policies"
  add_group "Services", "app/services"
  add_group "Uploaders", "app/uploaders"

  add_filter "app/operations/testing"
  add_filter "app/services/testing"
  add_filter "app/services/tus_client"
  add_filter "lib/cops"
  add_filter "lib/namespaces"
  add_filter "lib/patches"
end

require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "rspec/json_expectations"
require "test_prof/recipes/rspec/any_fixture"
require "test_prof/recipes/rspec/let_it_be"
require "dry/container/stub"
require "pundit/rspec"
require "webmock/rspec"

# Add additional requires below this line. Rails is not loaded until this point!

Rails.application.eager_load!

ActiveJob::Base.queue_adapter = :test

# ActiveJob::Uniqueness.test_mode!

Shrine.logger = Logger.new("/dev/null")

Dry::Effects.load_extensions :rspec

require_relative "system/test_container"

TestingAPI::TestContainer.finalize!

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

FactoryBot::Evaluator.include TestHelpers::Factories::SchemaHelpers

RSpec.configure do |config|
  # We use database cleaner to do this
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:redis].strategy = :deletion

    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:redis].clean_with(:deletion)

    Scenic.database.views.select(&:materialized).each do |view|
      Scenic.database.refresh_materialized_view view.name, concurrently: false, cascade: false
    end
  end

  config.before(:suite) do
    WebMock.disable_net_connect!
  end

  config.before(:suite) do
    Testing::InitializeTestDatabase.call
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
