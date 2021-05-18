# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.7.2"

# Rails / database
gem "rails", "~> 6.1.3.2"
gem "pg", "~> 1.2.3"
gem "activerecord-pg_enum"
gem "closure_tree", "~> 7.2.0"
gem "scenic", "~> 1.5.4"
gem "store_model", "~> 0.9.0"

# Redis
gem "hiredis", "~> 0.6.3"
gem "redis", "~> 4.2.5", require: %w[redis redis/connection/hiredis]

# GraphQL
gem "graphql", "1.12.8"
gem "graphql-guard", "~> 2.0.0"
gem "search_object_graphql", require: %w[search_object search_object/plugin/graphql]

# dry-rb
gem "dry-auto_inject", "~> 0.7.0"
gem "dry-effects", "~> 0.1.5"
gem "dry-initializer", "~> 3.0.4"
gem "dry-matcher", "~> 0.9.0"
gem "dry-monads", "~> 1.3.5"
gem "dry-rails", "~> 0.3.0"
gem "dry-struct", "~> 1.4.0"
gem "dry-transformer", "~> 0.1.1"
gem "dry-types", "~> 1.5.1"

# Keycloak
gem "keycloak-admin", "~> 0.7.9"
gem "keycloak_rack"

# Misc
gem "anyway_config", "~> 2.1.0"
gem "hashids", "~> 1.0.5"
gem "jwt", "~> 2.2.3"
gem "naught", "~> 1.1.0"
gem "pundit", "~> 2.1.0"
gem "validate_url", "~> 1.0.13"

# File processing
gem "aws-sdk-s3", "~> 1.94.1"
gem "fastimage"
gem "marcel", "~> 1.0.1"
gem "shrine", "~> 3.3.0"
gem "shrine-tus", "~> 2.1.1"
gem "ffi", "~> 1.15"
gem "mediainfo"
gem "tus-server", "~> 2.3"

# Servers / Rack
gem "falcon", "~> 0.38.1", require: false
gem "puma", "~> 5.3.1"
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
end

group :development do
  gem "listen", "~> 3.3"
  gem "rubocop", "~> 1.13.0"
  gem "rubocop-rails", "~> 2.9.1", require: false
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0.0"
  gem "database_cleaner-redis", "~> 2.0.0"
  gem "rspec-json_expectations", "~> 2.2.0"
  gem "webmock", "3.12.2"
end
