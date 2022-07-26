# frozen_string_literal: true

RSpec.describe Mutations::SelectInitialOrdering, type: :request, graphql: :mutation, simple_v1_hierarchy: true do
  mutation_query! <<~GRAPHQL
  mutation selectInitialOrdering($input: SelectInitialOrderingInput!) {
    selectInitialOrdering(input: $input) {
      entity { ... on Node { id } }
      ordering { id }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let!(:collection) { create_v1_collection }

  let!(:item) { create_v1_item collection: collection }

  let!(:ordering) { collection.orderings.by_identifier("subcollections").first! }

  let_mutation_input!(:entity_id) { collection.to_encoded_id }
  let_mutation_input!(:ordering_id) { ordering.to_encoded_id }

  let(:expected_shape) do
    gql.mutation(:select_initial_ordering) do |m|
      m.prop(:entity) do |e|
        e[:id] = entity_id
      end

      m.prop(:ordering) do |o|
        o[:id] = ordering_id
      end
    end
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with no previous selection" do
      before do
        collection.clear_initial_ordering!
      end

      it "selects a new ordering" do
        expect_request! do |req|
          req.effect! change(InitialOrderingSelection, :count).by(1)

          req.data! expected_shape
        end
      end

      context "when selecting a disabled ordering" do
        before do
          ordering.disable!
        end

        let(:expected_shape) do
          gql.mutation(:select_initial_ordering, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:ordering] = be_blank

            m.attribute_errors do |ae|
              ae.error :ordering, :must_not_be_disabled
            end
          end
        end

        it "fails to select an ordering" do
          expect_request! do |req|
            req.effect! keep_the_same(InitialOrderingSelection, :count)

            req.data! expected_shape
          end
        end
      end

      context "when selecting another entity's ordering" do
        let!(:other_collection) { create_v1_collection }

        let!(:ordering) { other_collection.orderings.first }

        let(:expected_shape) do
          gql.mutation(:select_initial_ordering, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:ordering] = be_blank

            m.attribute_errors do |ae|
              ae.error :ordering, :must_be_associated_with_entity
            end
          end
        end

        it "fails to select an ordering" do
          expect_request! do |req|
            req.effect! keep_the_same(InitialOrderingSelection, :count)

            req.data! expected_shape
          end
        end
      end
    end

    context "with a previous selection" do
      before do
        collection.select_initial_ordering!(ordering)
      end

      it "is idempotent" do
        expect_request! do |req|
          req.effect! keep_the_same(InitialOrderingSelection, :count)

          req.data! expected_shape
        end
      end
    end
  end
end
