# frozen_string_literal: true

RSpec.describe Mutations::UpdatePersonContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person, given_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let!(:mutation_input) do
      {
        contributorId: contributor.to_encoded_id,
        givenName: new_value,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updatePersonContributor: {
          contributor: {
            givenName: new_value
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updatePersonContributor($input: UpdatePersonContributorInput!) {
        updatePersonContributor(input: $input) {
          contributor {
            givenName
          }
        }
      }
      GRAPHQL
    end

    it "updates a contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { contributor.reload.properties.person.given_name }.from(old_value).to(new_value)

      expect_graphql_response_data expected_shape
    end
  end
end
