# frozen_string_literal: true

RSpec.describe Mutations::LinkEntity, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:source) { FactoryBot.create :collection }
    let!(:target) { FactoryBot.create :collection }
    let!(:operator) { "CONTAINS" }

    let!(:mutation_input) do
      {
        sourceId: source.to_encoded_id,
        targetId: target.to_encoded_id,
        operator: operator,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        linkEntity: {
          link: {
            id: be_present
          },
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation linkEntity($input: LinkEntityInput!) {
        linkEntity(input: $input) {
          link { id }

          errors { message }
        }
      }
      GRAPHQL
    end

    it "can link one entity to another" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(EntityLink, :count).by(1)

      expect_graphql_response_data expected_shape
    end

    context "with invalid inputs" do
      let!(:expected_shape) do
        {
          linkEntity: {
            link: be_blank,
            errors: be_present
          }
        }
      end

      shared_examples_for "a failed request" do
        it "fails" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to keep_the_same(EntityLink, :count)

          expect_graphql_response_data expected_shape
        end
      end

      context "when trying to link an entity to itself" do
        let!(:target) { source }

        include_examples "a failed request"
      end

      context "when trying to link an entity to its parent" do
        let!(:target) { source.contextual_parent }

        include_examples "a failed request"
      end

      context "when trying to link a parent to a child" do
        let!(:source) { target.contextual_parent }

        include_examples "a failed request"
      end
    end
  end
end
