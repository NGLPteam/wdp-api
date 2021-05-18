# frozen_string_literal: true

module TestHelpers
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
      expect(response.parsed_body).to include_json data: shape
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::ExampleHelpers, type: :request
end
