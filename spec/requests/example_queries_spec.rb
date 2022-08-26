# frozen_string_literal: true

RSpec.describe "Example Queries Controller", type: :request do
  include_context "standard requests"

  describe "GET /graphql/example_queries" do
    def make_request!
      get example_queries_path
    end

    it "renders example queries" do
      safely_make_request!

      expect(response).to be_successful

      expect(response.content_type).to match %r{\Aapplication/json}

      expect(response.parsed_body).to have(ExampleQuery.count).items
    end
  end
end
