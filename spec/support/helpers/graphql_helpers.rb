# frozen_string_literal: true

module TestHelpers
  module GraphQLRequest
    module ExampleHelpers
      def make_graphql_request!(query, token: nil, variables: {})
        headers = {}

        headers["ACCEPT"] = "application/json"
        headers["AUTHORIZATION"] = "Bearer #{token}" if token.present?
        headers["CONTENT_TYPE"] = "application/json"

        params = {
          query: query&.strip_heredoc&.strip
        }

        params[:variables] = variables if variables.present?

        post "/graphql", params: params.to_json, headers: headers
      end

      def expect_graphql_response_data(shape)
        expect(graphql_response).to include_json data: shape
      end

      def graphql_response(*path)
        response.parsed_body.with_indifferent_access.then do |res|
          path.present? ? res.dig(*path) : res
        end
      end

      def generate_slug_for(uuid)
        WDPAPI::Container["slugs.encode_id"].call(uuid).value_or(nil)
      end

      def random_slug
        generate_slug_for SecureRandom.uuid
      end

      def have_typename(name)
        include_json __typename: name
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::GraphQLRequest::ExampleHelpers, type: :request
end
