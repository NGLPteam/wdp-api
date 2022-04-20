# frozen_string_literal: true

# A namespace for interacting with the GraphQL API programmatically.
module APIWrapper
  # The path to where the client schema is cached.
  CLIENT_SCHEMA_PATH = Rails.root.join("lib/graphql/client_schema.json").to_s
end
