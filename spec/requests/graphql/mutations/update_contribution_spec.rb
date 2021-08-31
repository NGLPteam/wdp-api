# frozen_string_literal: true

RSpec.describe Mutations::UpdateContribution, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person }

    let!(:contribution) { nil }

    let!(:old_role) { "old role" }
    let!(:new_role) { "new role" }

    let!(:mutation_input) do
      {
        contribution_id: contribution.to_encoded_id,
        role: new_role,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateContribution($input: UpdateContributionInput!) {
        updateContribution(input: $input) {
          contribution {
            __typename

            ... on Node {
              id
            }

            ... on Contribution {
              role
            }
          }

          errors {
            message
          }
        }
      }
      GRAPHQL
    end

    shared_examples_for "updating" do
      it "updates the contribution" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    context "with a collection contribution" do
      let!(:contribution) { FactoryBot.create :collection_contribution, role: old_role, contributor: contributor }

      let(:expected_shape) do
        {
          update_contribution: {
            contribution: {
              __typename: "CollectionContribution",
              id: a_kind_of(String),
              role: new_role,
            },

            errors: be_blank,
          },
        }
      end

      include_examples "updating"
    end

    context "with an item" do
      let!(:contribution) { FactoryBot.create :item_contribution, role: old_role, contributor: contributor }

      let(:expected_shape) do
        {
          update_contribution: {
            contribution: {
              __typename: "ItemContribution",
              id: a_kind_of(String),
              role: new_role,
            },

            errors: be_blank,
          },
        }
      end

      include_examples "updating"
    end
  end
end
