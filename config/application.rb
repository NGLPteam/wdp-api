# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "../lib/patches/alter_store_model_mutation_tracking"
require_relative "../lib/patches/parse_graphql_json"
require_relative "../lib/patches/support_lquery"
require_relative "../lib/patches/support_regconfig"
require_relative "../lib/patches/support_semantic_version"
require_relative "../lib/patches/support_variable_precision_date"
require_relative "../lib/patches/set_search_path_for_dump"

module WDPAPI
  class Application < Rails::Application
    # Configure the path for configuration classes that should be used before initialization
    # NOTE: path should be relative to the project root (Rails.root)
    # config.anyway_config.autoload_static_config_path = "config/configs"
    #
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.active_record.schema_format = :sql

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.eager_load_paths << Rails.root.join("operations")
    config.eager_load_paths << Rails.root.join("services")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.integration_specs false

      g.orm :active_record, primary_key_type: :uuid
    end

    config.active_job.queue_adapter = :sidekiq
  end
end
