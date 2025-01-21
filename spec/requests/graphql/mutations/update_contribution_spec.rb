# frozen_string_literal: true

RSpec.describe Mutations::UpdateContribution, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updateContribution($input: UpdateContributionInput!) {
    updateContribution(input: $input) {
      contribution {
        __typename

        ... on Node {
          id
        }

        ... on Contribution {
          role
          roleLabel
          title
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:contributor, refind: true) { FactoryBot.create :contributor, :person }

  let(:contribution) { nil }

  let(:test_title) { "test title" }

  let_mutation_input!(:contribution_id) { contribution.to_encoded_id }
  let_mutation_input!(:metadata) { { title: test_title } }

  as_an_admin_user do
    shared_examples_for "updating" do
      let(:expected_shape) do
        gql.mutation :update_contribution do |m|
          m.prop :contribution do |con|
            con[:id] = contribution_id
            con[:role] = be_present
            con[:role_label] = be_present
            con[:title] = test_title

            con.typename(contribution.model_name.to_s)
          end
        end
      end

      it "updates the contribution" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "with a collection contribution" do
      let!(:contribution) { FactoryBot.create :collection_contribution, contributor: }

      include_examples "updating"
    end

    context "with an item" do
      let!(:contribution) { FactoryBot.create :item_contribution, contributor: }

      include_examples "updating"
    end
  end
end
