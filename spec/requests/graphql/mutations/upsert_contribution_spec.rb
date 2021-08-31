# frozen_string_literal: true

RSpec.describe Mutations::UpsertContribution, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person }

    let!(:role) { "test role" }

    let(:contributable) { nil }

    let!(:mutation_input) do
      {
        contributor_id: contributor.to_encoded_id,
        contributable_id: contributable&.to_encoded_id,
        role: role,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation upsertContribution($input: UpsertContributionInput!) {
        upsertContribution(input: $input) {
          contribution {
            __typename

            ... on Node {
              id
            }

            ... on Contribution {
              contributorKind
              displayName
            }
          }

          errors {
            message
          }
        }
      }
      GRAPHQL
    end

    shared_examples_for "upsertion" do
      it "upserts the contribution" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end

      it "is idempotent" do
        expect do
          make_default_request!
          make_default_request!
        end.to change(contributable.contributions_klass, :count).by(1)
      end
    end

    context "with a collection" do
      let!(:contributable) { FactoryBot.create :collection }

      let(:expected_shape) do
        {
          upsert_contribution: {
            contribution: {
              __typename: "CollectionContribution",
              id: a_kind_of(String),
              contributor_kind: "person",
              display_name: contributor.display_name,
            },

            errors: be_blank,
          },
        }
      end

      include_examples "upsertion"
    end

    context "with an item" do
      let!(:contributable) { FactoryBot.create :item }

      let(:expected_shape) do
        {
          upsert_contribution: {
            contribution: {
              __typename: "ItemContribution",
              id: a_kind_of(String),
              contributor_kind: "person",
              display_name: contributor.display_name,
            },

            errors: be_blank,
          },
        }
      end

      include_examples "upsertion"
    end
  end
end
