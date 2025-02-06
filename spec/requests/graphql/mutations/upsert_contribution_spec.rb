# frozen_string_literal: true

RSpec.describe Mutations::UpsertContribution, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation upsertContribution($input: UpsertContributionInput!) {
    upsertContribution(input: $input) {
      contribution {
        __typename

        ... on Node {
          id
        }

        ... on Contribution {
          contributionRole {
            id
          }

          contributorKind
          displayName

          innerPosition
          outerPosition
          roleLabel
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:vocabulary, refind: true) { FactoryBot.create :controlled_vocabulary }

  let_it_be(:contribution_role, refind: true) { FactoryBot.create :controlled_vocabulary_item, controlled_vocabulary: vocabulary }

  let_it_be(:collection, refind: true) { FactoryBot.create :collection }
  let_it_be(:item, refind: true) { FactoryBot.create :item }

  as_an_admin_user do
    let_it_be(:contributor, refind: true) { FactoryBot.create :contributor, :person }

    let(:contributable) { nil }

    let_mutation_input!(:contributor_id) { contributor.to_encoded_id }

    let_mutation_input!(:contributable_id) { contributable&.to_encoded_id }

    let_mutation_input!(:role_id) { contribution_role.to_encoded_id }

    let_mutation_input!(:role) { "test role" }

    let_mutation_input!(:outer_position) { 5 }

    let_mutation_input!(:inner_position) { 10 }

    shared_examples_for "upsertion" do
      it "upserts the contribution" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "with a collection" do
      let!(:contributable) { collection }

      let(:expected_shape) do
        gql.mutation :upsert_contribution do |m|
          m.prop :contribution do |c|
            c.typename("CollectionContribution")

            c[:id] = be_an_encoded_id
            c[:contributor_kind] = "person"
            c[:display_name] = contributor.display_name
            c[:inner_position] = inner_position
            c[:outer_position] = outer_position
            c[:role_label] = contribution_role.label

            c.prop :contribution_role do |cr|
              cr[:id] = role_id
            end
          end
        end
      end

      include_examples "upsertion"
    end

    context "with an item" do
      let(:contributable) { item }

      let(:expected_shape) do
        gql.mutation :upsert_contribution do |m|
          m.prop :contribution do |c|
            c.typename("ItemContribution")

            c[:id] = be_an_encoded_id
            c[:contributor_kind] = "person"
            c[:display_name] = contributor.display_name
            c[:inner_position] = inner_position
            c[:outer_position] = outer_position
            c[:role_label] = contribution_role.label

            c.prop :contribution_role do |cr|
              cr[:id] = role_id
            end
          end
        end
      end

      include_examples "upsertion"
    end
  end
end
