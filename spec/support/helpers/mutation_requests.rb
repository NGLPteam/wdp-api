# frozen_string_literal: true

require_relative "hash_setter"
require_relative "graphql_helpers"

module TestHelpers
  MutationInputHelpers = TestHelpers::HashSetter.new :mutation_input

  module MutationExampleHelpers
    def wrap_mutation_query(query)
      self.class.wrap_mutation_query(query)
    end
  end

  module MutationSpecHelpers
    ERROR_FRAGMENT = <<~GRAPHQL
    fragment ErrorFragment on StandardMutationPayload {
      attributeErrors {
        messages
        path
        type
      }

      globalErrors {
        message
        type
      }
    }
    GRAPHQL

    def mutation_query!(raw_query)
      wrapped_query = wrap_mutation_query raw_query

      let!(:query) { wrapped_query }
    end

    def wrap_mutation_query(raw_query)
      <<~GRAPHQL
      #{raw_query}

      #{ERROR_FRAGMENT}
      GRAPHQL
    end
  end
end

RSpec.shared_context "mutation requests" do
  include_context "with default graphql context"

  let(:mutation_error_partial) do
    <<~GRAPHQL
    GRAPHQL
  end

  let(:graphql_variables) do
    {
      input: mutation_input
    }
  end
end

RSpec.configure do |config|
  config.include TestHelpers::MutationInputHelpers, graphql: :mutation
  config.include TestHelpers::MutationExampleHelpers, graphql: :mutation
  config.extend TestHelpers::MutationSpecHelpers, graphql: :mutation
  config.include_context "mutation requests", graphql: :mutation
end
