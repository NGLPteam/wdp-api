# frozen_string_literal: true

RSpec.describe CollectionPolicy, type: :policy do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  let_it_be(:community) { FactoryBot.create :community }

  let_it_be(:collection, refind: true) { FactoryBot.create :collection, community:, title: "Collection" }

  let_it_be(:subcollection, refind: true) { FactoryBot.create :collection, parent: collection, title: "Subcollection" }

  let_it_be(:other_community, refind: true) { FactoryBot.create :community }

  let_it_be(:other_collection, refind: true) { FactoryBot.create :collection, community: other_community, title: "Other Collection" }

  let_it_be(:manager_role) { FactoryBot.create :role, :manager }

  let_it_be(:editor_role) { FactoryBot.create :role, :editor }

  let_it_be(:contextual_role) { FactoryBot.create :role, :all_contextual }

  let(:scope) { described_class::Scope.new(user, Collection.all) }

  subject { described_class }

  context "as an admin" do
    let_it_be(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include collection, subcollection, other_collection
      end
    end

    permissions :read?, :show?, :create?, :update?, :destroy? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end
    end

    permissions :create_collections?, :create_items? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end
    end
  end

  context "as a user with manager access on the parent community" do
    before do
      grant_access! manager_role, on: community, to: user
    end

    permissions :read?, :show? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end
    end

    permissions :create?, :update?, :destroy? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end

    permissions :manage_access? do
      it "is allowed on the collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end

    permissions :create_collections?, :create_items? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end
  end

  context "as a user with editor access on the parent community" do
    before do
      grant_access! editor_role, on: community, to: user
    end

    permissions :read?, :show? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end
    end

    permissions :create?, :destroy? do
      it "is not allowed on a collection" do
        is_expected.not_to permit(user, collection)
      end

      it "is not allowed on a subcollection" do
        is_expected.not_to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end

    permissions :update? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end

    permissions :manage_access? do
      it "is not allowed on the collection" do
        is_expected.not_to permit(user, collection)
      end

      it "is not allowed on a subcollection" do
        is_expected.not_to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end

    permissions :create_collections?, :create_items? do
      it "is not allowed on a collection" do
        is_expected.not_to permit(user, collection)
      end

      it "is not allowed on a subcollection" do
        is_expected.not_to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end
  end

  context "as a user with all contextual permissions" do
    before do
      grant_access! contextual_role, on: collection, to: user
    end

    permissions :read?, :show?, :create?, :update?, :destroy? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end
    end

    permissions :manage_access? do
      it "is not allowed" do
        is_expected.not_to permit(user, collection)
      end
    end

    permissions :create_collections?, :create_items? do
      it "is allowed on a collection" do
        is_expected.to permit(user, collection)
      end

      it "is allowed on a subcollection" do
        is_expected.to permit(user, subcollection)
      end

      it "is not allowed on an unrelated collection" do
        is_expected.not_to permit(user, other_collection)
      end
    end
  end

  context "as a random user with no permissions" do
    permissions ".scope" do
      before do
        other_collection.update!(visibility: :hidden)
      end

      subject { scope.resolve }

      it "excludes hidden records" do
        is_expected.to exclude(other_collection).and include(collection, subcollection)
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit(user, collection)
      end
    end

    permissions :read?, :create?, :update?, :destroy? do
      it "is not allowed" do
        is_expected.not_to permit(user, collection)
      end
    end

    context "when the collection is hidden" do
      before do
        collection.update!(visibility: :hidden)
      end

      permissions :show? do
        it "is disallowed" do
          is_expected.not_to permit user, collection
        end
      end
    end
  end

  context "as an anonymous user" do
    let_it_be(:user) { AnonymousUser.new }

    permissions ".scope" do
      before do
        other_collection.update!(visibility: :hidden)
      end

      subject { scope.resolve }

      it "excludes hidden records" do
        is_expected.to exclude(other_collection).and include(collection, subcollection)
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit(user, collection)
      end
    end

    permissions :read?, :create?, :update?, :destroy? do
      it "is not allowed" do
        is_expected.not_to permit(user, collection)
      end
    end

    context "when the collection is hidden" do
      before do
        collection.update!(visibility: :hidden)
      end

      permissions :show? do
        it "is disallowed" do
          is_expected.not_to permit user, collection
        end
      end
    end
  end
end
