# frozen_string_literal: true

RSpec.describe Mutations::CreateOrganizationContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:identifier) { SecureRandom.uuid }
    let!(:url) { Faker::Internet.url }
    let!(:bio) { Faker::Lorem.paragraphs(number: 4).join("\n") }

    let!(:links) do
      2.times.map do
        { title: Faker::Lorem.sentence, url: Faker::Internet.url }
      end
    end

    let(:properties) do
      {
        legalName: Faker::Company.name,
        location: Faker::Address.full_address,
      }
    end

    let!(:mutation_input) do
      {
        identifier: identifier,
        url: url,
        bio: bio,
        links: links,
      }.merge(properties)
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createOrganizationContributor: {
          contributor: {
            kind: "organization"
          },

          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createOrganizationContributor($input: CreateOrganizationContributorInput!) {
        createOrganizationContributor(input: $input) {
          contributor {
            kind
          }

          errors {
            message
          }
        }
      }
      GRAPHQL
    end

    it "creates an organization contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Contributor, :count).by(1)

      expect_graphql_response_data expected_shape
    end
  end
end
