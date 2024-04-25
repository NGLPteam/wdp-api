# frozen_string_literal: true

# Example GraphQL Queries served up on `/graphql/example_queries`.
class ExampleQuery < FrozenRecord::Base
  include FrozenArel
  include FrozenSchema

  EXAMPLE_QUERIES_PATH = Rails.root.join("lib", "example_queries")

  IDENTIFIER_FORMAT = /\A[a-z][a-z-]+[a-z]\z/

  self.primary_key = :identifier

  add_index :identifier, unique: true

  schema! do
    required(:identifier).filled(:string) do
      format?(IDENTIFIER_FORMAT)
    end
    required(:description).filled(:string)
    required(:query).filled(:string)
  end

  class << self
    def assign_defaults!(record)
      example_query_file = "#{record['identifier']}.graphql"

      example_query_path = EXAMPLE_QUERIES_PATH.join example_query_file

      record["query"] = example_query_path.read

      super
    end
  end
end
