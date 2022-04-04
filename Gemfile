# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.7.3"

# Rails / database
gem "rails", "~> 6.1.4"
gem "pg", "~> 1.2.3"
gem "activerecord-cte"
gem "activerecord-pg_enum"
gem "active_record_distinct_on", "~> 1.3.0"
gem "closure_tree", "~> 7.2.0"
gem "composite_primary_keys", "13.0.0"
gem "frozen_record"
gem "pg_query"
gem "retryable", "~> 3.0.5"
gem "scenic", "~> 1.5.4"
gem "store_model", "~> 0.12.0"

# Redis / Jobs
gem "activejob-uniqueness"
gem "dalli", "~> 2.7.11"
gem "hiredis", "~> 0.6.3"
gem "redis", "~> 4.2.5", require: %w[redis redis/connection/hiredis]
gem "sidekiq", "~> 6.2.1"
gem "redis-objects", "~> 1.5.1"
gem "job-iteration"
gem "zhong", "~> 0.3.0"

# GraphQL
gem "graphql", "1.12.8"
gem "graphql-batch", "~> 0.4.3"
gem "graphql-guard", "~> 2.0.0"
gem "search_object_graphql", require: %w[search_object search_object/plugin/graphql]

# dry-rb
gem "dry-auto_inject", "~> 0.7.0"
gem "dry-core", "~> 0.7.1"
gem "dry-effects", "~> 0.1.5"
gem "dry-files", "~> 0.1.0"
gem "dry-initializer", "~> 3.0.4"
gem "dry-matcher", "~> 0.9.0"
gem "dry-monads", "~> 1.3.5"
gem "dry-rails", "~> 0.5.0"
gem "dry-schema", "~> 1.9.1"
gem "dry-struct", "~> 1.4.0"
gem "dry-transformer", "~> 0.1.1"
gem "dry-types", "~> 1.5.1"
gem "dry-validation", "~> 1.8.0"

# Keycloak
gem "keycloak-admin", "~> 0.7.9"
gem "keycloak_rack", "1.1.1"

# Misc
gem "acts_as_list", "~> 1.0.4"
gem "addressable", ">= 2.8.0"
gem "anyway_config", "~> 2.1.0"
gem "hashids", "~> 1.0.5"
gem "iso-639", "~> 0.3.5"
gem "json-schema", "~> 2.8.1"
gem "json_schemer", "~> 0.2.18"
gem "jwt", "~> 2.2.3"
gem "kramdown", "~> 2.3.1"
gem "memoist", "~> 0.16.2"
gem "mods", "~> 2.4.1"
gem "namae", "~> 1.1.1"
gem "naught", "~> 1.1.0"
gem "nokogiri", "~> 1.12.5"
gem "oai", "~> 1.1.0"
gem "openid_connect"
gem "pundit", "~> 2.1.0"
gem "semantic", "~> 1.6.1"
gem "statesman", "~> 9.0.0"
gem "strip_attributes", "1.11.0"
gem "validate_url", "~> 1.0.13"

# File processing
gem "aws-sdk-s3", "~> 1.94.1"
gem "content_disposition", "~> 1.0.0"
gem "fastimage"
gem "image_processing", "~> 1.12.2"
gem "marcel", "~> 1.0.1"
gem "oily_png", "~> 1.2.1"
gem "shrine", "~> 3.3.0"
gem "shrine-tus", "~> 2.1.1"
gem "shrine-url", "~> 2.4.1"
gem "ffi", "~> 1.15"
gem "mediainfo"
gem "tus-server", "~> 2.3"

# Servers / Rack
gem "falcon", "~> 0.39.0", require: false
gem "puma", "~> 5.6.2"
gem "rack-cors", "~> 1.1.1"

# Debugging / system-level things
gem "bootsnap", ">= 1.7.5", require: false
gem "pry-rails", "~> 0.3.9"

# Temporary test gems for production usage
gem "faker", "~> 2.17.0"
gem "factory_bot_rails", "~> 6.2.0"

group :development, :test do
  gem "rspec", "~> 3.10.0"
  gem "rspec-rails", "~> 5.0.1"
  gem "yard", "~> 0.9.27"
  gem "yard-activerecord", "~> 0.0.16"
  gem "yard-activesupport-concern", "~> 0.0.1"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rubocop", "~> 1.13.0"
  gem "rubocop-rails", "~> 2.9.1", require: false
  gem "rubocop-rspec", "~> 2.4.0", require: false
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0.0"
  gem "database_cleaner-redis", "~> 2.0.0"
  gem "rspec-collection_matchers", "~> 1.2.0"
  gem "rspec-json_expectations", "~> 2.2.0"
  gem "simplecov", "~> 0.21.2", require: false
  gem "timecop", "~> 0.9.4"
  gem "webmock", "3.12.2"
end
