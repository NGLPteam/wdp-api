# frozen_string_literal: true

module APIWrapper
  class Wrapper
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :client, AppTypes.Instance(::GraphQL::Client)
      param :token, AppTypes::String.optional
    end

    def viewer
      read_query viewer_query
    end

    private

    def read_query(query)
      client.query query, context: build_context
    end

    def build_context
      {
        token:,
      }
    end

    memoize def viewer_query
      client.parse <<~GRAPHQL
      query {
        viewer {
          id
          name
          email
          allowedActions
        }
      }
      GRAPHQL
    end
  end
end
