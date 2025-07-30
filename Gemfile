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
gem "activerecord-cte", "~> 0.4.0"
# Later versions of this break compatibility with using arel
# and distinct on joined tables. Holding off for now.
gem "active_record_distinct_on", "1.3.0"
gem "after_commit_everywhere", "~> 1.6.0"
gem "closure_tree", "~> 7.4.0"
gem "composite_primary_keys", "14.0.6"
gem "frozen_record", "~> 0.27.1"
gem "pghero", "~> 3.4.1"
gem "pg_query", "~> 5.1.0"
gem "pg_search", "~> 2.3.7"
gem "retryable", "~> 3.0.5"
gem "scenic", "~> 1.8.0"
gem "store_model", "~> 4.2.1"

# Redis / Jobs
gem "good_job", "~> 4.9.0"
gem "redis", "~> 5.4.0"
gem "redis-objects", ">= 2.0.0.beta"
gem "job-iteration", "~> 1.9.0"

# GraphQL
gem "graphql", "2.4.14"
gem "graphql-batch", "~> 0.6.0"
gem "graphql-client", "~> 0.25.0"
gem "graphql-fragment_cache", "~> 1.22.0"
gem "search_object_graphql", "~> 1.0.5", require: %w[search_object search_object/plugin/graphql]

# dry-rb
gem "dry-auto_inject", "~> 1.1"
gem "dry-core", "~> 1.1.0"
gem "dry-effects", "~> 0.4.1"
gem "dry-files", "~> 1.1.0"
gem "dry-initializer", "~> 3.2.0"
gem "dry-logic", "~> 1.6.0"
gem "dry-matcher", "~> 1.0.0"
gem "dry-monads", "~> 1.8.1"
gem "dry-rails", "~> 0.7.0"
gem "dry-schema", "~> 1.13.0"
gem "dry-struct", "~> 1.6.0"
gem "dry-system", "~> 1.2.2"
gem "dry-transformer", "~> 1.0"
gem "dry-types", "~> 1.7.1"
gem "dry-validation", "~> 1.10.0"

# Keycloak / Auth
gem "bcrypt", "~> 3.1.18"
gem "keycloak-admin", "~> 1.1.3"
gem "keycloak_rack", "1.1.1"

# Metadata Parsing
gem "lutaml-model", "~> 0.7.3"
gem "lutaml-xsd", "~> 1.0.3"
gem "mods", "~> 3.0.4"
gem "niso-jats", "~> 0.1.1"

# Misc
gem "absolute_time", "~> 1.0.0"
gem "acts_as_list", "~> 1.2.4"
gem "addressable", ">= 2.8.0"
gem "ahoy_matey", "~> 4.1.0"
gem "anystyle", "~> 1.6.0"
gem "anyway_config", "~> 2.3.0"
gem "down", "~> 5.4.2"
gem "faraday", "~> 2.13.1"
gem "faraday-follow_redirects", "~> 0.3.0"
gem "faraday-retry", "~> 2.3.1"
gem "fugit", "~> 1.11.1"
gem "geocoder", "~> 1.8.0"
gem "groupdate", "~> 6.5.1"
gem "hashids", "~> 1.0.6"
gem "htmlbeautifier", "~> 1.4.3"
gem "iso-639", "~> 0.3.8"
gem "jbuilder", "~> 2.13.0"
gem "json-ld", "~> 3.3.2"
gem "json-schema", "~> 2.8.1"
gem "json_schemer", "~> 0.2.18"
gem "jwt", "~> 2.8.2"
gem "kramdown", "~> 2.5.1"
gem "link-header-parser", "~> 7.0.1"
gem "liquid", "~> 5.8.1"
gem "maxminddb", "~> 0.1.22"
gem "namae", "~> 1.2.0"
gem "naught", "~> 1.1.0"
gem "nokogiri", "~> 1.18.8"
gem "oai", "~> 1.2.1"
gem "oj", "3.16.10"
gem "openid_connect", "~> 2.3.0"
gem "ox", "~> 2.14.18"
gem "pundit", "~> 2.5.0"
gem "redcarpet", "~> 3.6.0"
gem "reverse_markdown", "~> 3.0.0"
gem "rufus-scheduler", "~> 3.9.2"
gem "sanitize", "~> 7.0.0"
gem "semantic", "~> 1.6.1"
gem "shale", "~> 1.2.1"
gem "sinatra", "~> 3.2.0", require: "sinatra/base"
gem "sinatra-contrib", "~> 3.2.0", require: false
gem "statesman", "~> 12.1.0"
gem "strip_attributes", "~> 2.0.0"
gem "sucker_punch", "~> 3.2.0"
gem "tomlib", "~> 0.7.2"
gem "validate_url", "~> 1.0.15"

# File processing
gem "aws-sdk-s3", "~> 1.146.1"
gem "content_disposition", "~> 1.0.0"
gem "fastimage", "~> 2.4.0"
gem "image_processing", "~> 1.14.0"
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
gem "puma", "~> 6.6.0"
gem "puma-rufus-scheduler", "~> 0.1.0"
gem "puma_worker_killer", "~> 1.0.0", require: false
gem "rack", "~> 2.2.14"
gem "rack-cors", "~> 2.0.2"

# Debugging / system-level things
gem "bootsnap", ">= 1.18.3", require: false
gem "pry-rails", "~> 0.3.11"
gem "pry", "~> 0.15.2"

# Temporary test gems for production usage
gem "faker", "~> 3.5.1"

group :development, :test do
  gem "factory_bot_rails", "~> 6.4.4"
  gem "rspec", "~> 3.13.0"
  gem "rspec-rails", "~> 7.1.1"
  gem "yard", "~> 0.9.34"
  gem "yard-activerecord", "~> 0.0.16"
  gem "yard-activesupport-concern", "~> 0.0.1"
end

group :development do
  gem "listen", "~> 3.9.0"
  gem "rubocop", "1.74.0", require: false
  gem "rubocop-factory_bot", "2.27.1", require: false
  gem "rubocop-rails", "2.30.3", require: false
  gem "rubocop-rspec", "3.5.0", require: false
  gem "rubocop-rspec_rails", "2.31.0", require: false
  gem "ruby-prof", "~> 1.7.1", require: false
  gem "stackprof", "~> 0.2.25", require: false
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0.1"
  gem "database_cleaner-redis", "~> 2.0.0"
  gem "pundit-matchers", "~> 4.0.0"
  gem "rspec-collection_matchers", "~> 1.2.0"
  gem "rspec-json_expectations", "~> 2.2.0"
  gem "simplecov", "~> 0.22.0", require: false
  gem "test-prof", "~> 1.4.4"
  gem "timecop", "~> 0.9.8"
  gem "webmock", "3.25.1"
end
