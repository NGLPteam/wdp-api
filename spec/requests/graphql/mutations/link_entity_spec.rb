# frozen_string_literal: true

RSpec.describe Mutations::LinkEntity, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation linkEntity($input: LinkEntityInput!) {
    linkEntity(input: $input) {
      link { id }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:source_collection, refind: true) { FactoryBot.create :collection }
  let_it_be(:target_collection, refind: true) { FactoryBot.create :collection }

  let!(:source) { source_collection }
  let!(:target) { target_collection }

  as_an_admin_user do
    let_mutation_input!(:source_id) { source.to_encoded_id }
    let_mutation_input!(:target_id) { target.to_encoded_id }
    let_mutation_input!(:operator) { "CONTAINS" }

    let(:expected_shape) do
      gql.mutation :link_entity do |m|
        m.prop :link do |l|
          l[:id] = be_an_encoded_id
        end
      end
    end

    it "can link one entity to another" do
      expect_request! do |req|
        req.effect! change(EntityLink, :count).by(1)

        req.data! expected_shape
      end
    end

    context "with invalid inputs" do
      let(:expected_shape) do
        gql.mutation :link_entity, no_global_errors: false do |m|
          m[:link] = be_blank
        end
      end

      shared_examples_for "a failed request" do
        it "fails" do
          expect_request! do |req|
            req.effect! keep_the_same(EntityLink, :count)

            req.data! expected_shape
          end
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
