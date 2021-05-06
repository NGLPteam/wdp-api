# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.7.2"

gem "rails", "~> 6.1.3", ">= 6.1.3.1"
gem "pg", "~> 1.2.3"
gem "scenic", "~> 1.5.4"

gem "graphql", "1.12.8"
gem "graphql-guard", "~> 2.0.0"
gem "search_object_graphql", require: %w[search_object search_object/plugin/graphql]

gem "aws-sdk-s3", "~> 1.94.0"

gem "anyway_config", "~> 2.1.0"

gem "dry-auto_inject", "~> 0.7.0"
gem "dry-effects", "~> 0.1.5"
gem "dry-initializer", "~> 3.0.4"
gem "dry-matcher", "~> 0.9.0"
gem "dry-monads", "~> 1.3.5"
gem "dry-rails", "~> 0.3.0"
gem "dry-struct", "~> 1.4.0"
gem "dry-transformer", "~> 0.1.1"
gem "dry-types", "~> 1.5.1"

gem "keycloak-admin", "~> 0.7.9"
gem "keycloak_rack"

gem "hashids", "~> 1.0.5"
gem "jwt", "~> 2.2.3"
gem "naught", "~> 1.1.0"
gem "pundit", "~> 2.1.0"

gem "rack-cors", "~> 1.1.1"

gem "puma", "~> 5.2.2"

gem "pry-rails", "~> 0.3.9"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "faker", "~> 2.17.0"
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
end
