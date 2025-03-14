# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.3"

# stdlib
gem "csv", "~> 3.3.0"
gem "sorted_set", "~> 1.0.3"
gem "stringio", "~> 3.1.2"

gem "activesupport", "~> 7.0"
gem "activerecord", "~> 7.0"

# Rails / database
gem "rails", "~> 7.0.8.7"
gem "pg", "~> 1.5.4"
gem "activerecord-cte", "~> 0.3.0"
gem "active_record_distinct_on", "~> 1.3.0"
gem "after_commit_everywhere", "~> 1.3.1"
gem "closure_tree", "~> 7.4.0"
gem "composite_primary_keys", "14.0.6"
gem "frozen_record", "~> 0.27.1"
gem "pghero", "~> 3.4.1"
gem "pg_query", "~> 5.1.0"
gem "retryable", "~> 3.0.5"
gem "scenic", "~> 1.6.0"
gem "store_model", "~> 4.1.0"

# Redis / Jobs
gem "good_job", "~> 4.9.0"
gem "redis", "~> 5.2.0"
gem "redis-objects", ">= 2.0.0.beta"
gem "job-iteration", "~> 1.9.0"

# GraphQL
gem "graphql", "2.4.13"
gem "graphql-anycable", "1.1.5"
gem "graphql-batch", "~> 0.6.0"
gem "graphql-client", "~> 0.21.0"
gem "graphql-fragment_cache", "~> 1.20.5"
gem "search_object_graphql", "~> 1.0.5", require: %w[search_object search_object/plugin/graphql]

# dry-rb
gem "dry-auto_inject", "~> 1.0.1"
gem "dry-core", "~> 1.0.0"
gem "dry-effects", "~> 0.4.1"
gem "dry-files", "~> 1.1.0"
gem "dry-initializer", "~> 3.1.1"
gem "dry-matcher", "~> 1.0.0"
gem "dry-monads", "~> 1.6.0"
gem "dry-rails", "~> 0.7.0"
gem "dry-schema", "~> 1.13.0"
gem "dry-struct", "~> 1.6.0"
gem "dry-system", "~> 1.0.1"
gem "dry-transformer", "~> 1.0"
gem "dry-types", "~> 1.7.1"
gem "dry-validation", "~> 1.10.0"

# Keycloak / Auth
gem "bcrypt", "~> 3.1.18"
gem "keycloak-admin", "~> 0.7.9"
gem "keycloak_rack", "1.1.1"

# Metadata Parsing
gem "lutaml-model", "~> 0.6.7"
gem "lutaml-xsd", "~> 1.0.3"
gem "mods", "~> 3.0.4"
gem "niso-jats", "~> 0.1.1"

# Misc
gem "absolute_time", "~> 1.0.0"
gem "acts_as_list", "~> 1.0.4"
gem "addressable", ">= 2.8.0"
gem "ahoy_matey", "~> 4.1.0"
gem "anystyle", "~> 1.5.0"
gem "anyway_config", "~> 2.3.0"
gem "faraday", "~> 2.9.0"
gem "faraday-follow_redirects", "~> 0.3.0"
gem "faraday-retry", "~> 2.2.1"
gem "geocoder", "~> 1.8.0"
gem "groupdate", "~> 6.1.0"
gem "hashids", "~> 1.0.6"
gem "htmlbeautifier", "~> 1.4.3"
gem "iso-639", "~> 0.3.6"
gem "jbuilder", "~> 2.11.5"
gem "json-schema", "~> 2.8.1"
gem "json_schemer", "~> 0.2.18"
gem "jwt", "~> 2.8.2"
gem "kramdown", "~> 2.4.0"
gem "liquid", "~> 5.6.0.rc1"
gem "maxminddb", "~> 0.1.22"
gem "namae", "~> 1.2.0"
gem "naught", "~> 1.1.0"
gem "nokogiri", "~> 1.18.3"
gem "oai", "~> 1.2.1"
gem "oj", "3.16.3"
gem "openid_connect", "~> 2.3.0"
gem "ox", "~> 2.14.18"
gem "pundit", "~> 2.3.1"
gem "redcarpet", "~> 3.6.0"
gem "reverse_markdown", "~> 3.0.0"
gem "rollups", "~> 0.3.2"
gem "rufus-scheduler", "~> 3.9.2"
gem "sanitize", "~> 6.1.0"
gem "semantic", "~> 1.6.1"
gem "shale", "~> 1.2.1"
gem "statesman", "~> 12.1.0"
gem "strip_attributes", "1.13.0"
gem "sucker_punch", "~> 3.2.0"
gem "tomlib", "~> 0.7.2"
gem "validate_url", "~> 1.0.15"

# File processing
gem "aws-sdk-s3", "~> 1.146.1"
gem "content_disposition", "~> 1.0.0"
gem "fastimage", "~> 2.3.1"
gem "image_processing", "~> 1.12.2"
gem "marcel", "~> 1.0.4"
gem "oily_png", "~> 1.2.1"
gem "shrine", "~> 3.5.0"
gem "shrine-tus", "~> 2.1.1"
gem "shrine-url", "~> 2.4.1"
gem "ffi", "~> 1.16.3"
gem "mediainfo", "~> 1.5.0"
gem "tus-server", "~> 2.3.0"
gem "zaru", "~> 1.0.0"

# Servers / Rack
gem "puma", "~> 6.4.2"
gem "puma-rufus-scheduler", "~> 0.1.0"
gem "rack-cors", "~> 2.0.2"

# Debugging / system-level things
gem "bootsnap", ">= 1.18.3", require: false
gem "pry-rails", "~> 0.3.9"
gem "pry", "~> 0.14.2"

# Temporary test gems for production usage
gem "faker", "~> 2.21.0"

group :development, :test do
  gem "factory_bot_rails", "~> 6.2.0"
  gem "rspec", "~> 3.11.0"
  gem "rspec-rails", "~> 5.1.2"
  gem "yard", "~> 0.9.34"
  gem "yard-activerecord", "~> 0.0.16"
  gem "yard-activesupport-concern", "~> 0.0.1"
end

group :development do
  gem "listen", "~> 3.7.1"
  gem "rubocop", "1.56.4"
  gem "rubocop-rails", "2.21.2", require: false
  gem "rubocop-rspec", "2.24.1", require: false
  gem "ruby-prof", "~> 1.7.0", require: false
  gem "stackprof", "~> 0.2.25", require: false
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0.1"
  gem "database_cleaner-redis", "~> 2.0.0"
  gem "pundit-matchers", "~> 1.7.0"
  gem "rspec-collection_matchers", "~> 1.2.0"
  gem "rspec-json_expectations", "~> 2.2.0"
  gem "simplecov", "~> 0.22.0", require: false
  gem "test-prof", "~> 1.3.3"
  gem "timecop", "~> 0.9.8"
  gem "webmock", "3.19.1"
end
