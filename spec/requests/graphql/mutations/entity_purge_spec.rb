# frozen_string_literal: true

RSpec.describe Mutations::EntityPurge, type: :request, graphql: :mutation, grants_access: true do
  mutation_query! <<~GRAPHQL
  mutation EntityPurge($input: EntityPurgeInput!) {
    entityPurge(input: $input) {
      jobEnqueued
      entity {
        markedForPurge
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:manager_role) { FactoryBot.create :role, :manager }

  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:collection_1, refind: true) { FactoryBot.create :collection, community: }
  let_it_be(:collection_1_1, refind: true) { FactoryBot.create :collection, parent: collection_1, community: }
  let_it_be(:collection_2, refind: true) { FactoryBot.create :collection, community: }

  let_it_be(:item_1, refind: true) { FactoryBot.create :item, collection: collection_1 }
  let_it_be(:item_1_1, refind: true) { FactoryBot.create :item, collection: collection_1, parent: item_1 }

  let_it_be(:link, refind: true) { collection_2.link_to! item_1_1, operator: :references }

  let_mutation_input!(:entity_id) { community.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:entity_purge) do |m|
      m[:job_enqueued] = true

      m.prop :entity do |ent|
        ent[:marked_for_purge] = true
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :entity_purge
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "enqueues a job to purge the entity and marks the whole tree for purge" do
      expect_request! do |req|
        req.effect! keep_the_same(Community, :count)
        req.effect! keep_the_same(Collection, :count)
        req.effect! keep_the_same(Item, :count)
        req.effect! keep_the_same(EntityLink, :count)
        req.effect! change { community.reload.marked_for_purge }.from(false).to(true)
        req.effect! change { collection_1.reload.marked_for_purge }.from(false).to(true)
        req.effect! change { collection_1_1.reload.marked_for_purge }.from(false).to(true)
        req.effect! change { collection_2.reload.marked_for_purge }.from(false).to(true)
        req.effect! change { item_1.reload.marked_for_purge }.from(false).to(true)
        req.effect! change { item_1_1.reload.marked_for_purge }.from(false).to(true)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(Community, :count)
        req.effect! keep_the_same(Collection, :count)
        req.effect! keep_the_same(Item, :count)
        req.effect! keep_the_same(EntityLink, :count)
        req.effect! keep_the_same { community.reload.marked_for_purge }
        req.effect! keep_the_same { collection_1.reload.marked_for_purge }
        req.effect! keep_the_same { collection_1_1.reload.marked_for_purge }
        req.effect! keep_the_same { collection_2.reload.marked_for_purge }
        req.effect! keep_the_same { item_1.reload.marked_for_purge }
        req.effect! keep_the_same { item_1_1.reload.marked_for_purge }

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    it_behaves_like "a successful mutation"
  end

  as_a_regular_user do
    context "when the user has been granted full access" do
      before do
        grant_access! manager_role, on: community, to: current_user
      end

      it_behaves_like "an unauthorized mutation"
    end

    it_behaves_like "an unauthorized mutation"
  end

  as_an_anonymous_user do
    it_behaves_like "an unauthorized mutation"
  end
end
