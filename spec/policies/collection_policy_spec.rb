# frozen_string_literal: true

RSpec.describe CollectionPolicy, type: :policy do
  let!(:user) { FactoryBot.create :user }

  let!(:collection) { FactoryBot.create :collection }

  let!(:subcollection) { FactoryBot.create :collection, parent: collection }

  let!(:other_collection) { FactoryBot.create :collection }

  let!(:editor_role) { FactoryBot.create :role, :editor }

  let!(:scope) { described_class::Scope.new(user, Collection.all) }

  subject { described_class }

  context "as an admin" do
    let!(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include collection, subcollection, other_collection
      end
    end

    permissions :show?, :create?, :update?, :destroy? do
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

  context "as a user with all contextual permissions" do
    before do
      grant_access! editor_role, on: collection, to: user
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "includes what the user has read access to" do
        is_expected.to include collection, subcollection
      end

      it "excludes what a user can't see" do
        is_expected.not_to include other_collection
      end
    end

    permissions :show?, :create?, :update?, :destroy? do
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

  context "as a random user with no permissions" do
    permissions ".scope" do
      subject { scope.resolve }

      it "is empty" do
        is_expected.to be_blank
      end
    end

    permissions :show?, :create?, :update?, :destroy? do
      it "is not allowed on a collection" do
        is_expected.not_to permit(user, collection)
      end
    end
  end
end
