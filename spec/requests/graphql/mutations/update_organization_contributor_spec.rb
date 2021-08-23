# frozen_string_literal: true

RSpec.describe Mutations::UpdateOrganizationContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :organization, legal_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let!(:mutation_input) do
      {
        contributorId: contributor.to_encoded_id,
        legalName: new_value,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updateOrganizationContributor: {
          contributor: {
            legalName: new_value
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateOrganizationContributor($input: UpdateOrganizationContributorInput!) {
        updateOrganizationContributor(input: $input) {
          contributor {
            legalName
          }
        }
      }
      GRAPHQL
    end

    it "updates a contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { contributor.reload.properties.organization.legal_name }.from(old_value).to(new_value)

      expect_graphql_response_data expected_shape
    end
  end
end
