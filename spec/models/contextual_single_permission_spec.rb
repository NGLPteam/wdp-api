# frozen_string_literal: true

RSpec.describe ContextualSinglePermission, type: :model do
  let_it_be(:role) { FactoryBot.create :role, :editor }

  let_it_be(:user) { FactoryBot.create :user }

  let_it_be(:community) { FactoryBot.create :community }

  let_it_be(:collection, refind: true) { FactoryBot.create :collection, community: }

  let_it_be(:item, refind: true) { FactoryBot.create :item, collection: }

  let_it_be(:subitem, refind: true) { FactoryBot.create :item, parent: item, collection: }

  let!(:accessible) { community }

  let!(:access_grant) { FactoryBot.create :access_grant, accessible:, role:, subject: user }

  context "when inheriting permissions from a community" do
    specify "the community inherits permissions" do
      expect(community).to have_permitted_actions_for(user, "self.read", "self.update")
    end

    specify "a collection inherits permissions" do
      expect(collection).to have_permitted_actions_for(user, "self.read", "self.update", "collections.read", "collections.assets.read", "items.read")
    end

    specify "an item inherits permissions" do
      expect(item).to have_permitted_actions_for(user, "self.read", "self.update", "items.read")

      # it does not include collection permissions
      expect(item).not_to have_permitted_actions_for(user, "collections.read")
    end

    specify "a subitem inherits permissions" do
      expect(subitem).to have_permitted_actions_for(user, "self.read", "self.update", "items.assets.read")

      # it does not include collection permissions
      expect(subitem).not_to have_permitted_actions_for(user, "collections.read")
    end
  end

  context "when inheriting permissions from a collection" do
    let!(:accessible) { collection }

    specify "the parent community does not have any permissions" do
      expect(community).not_to have_permitted_actions_for(user, "self.read")
    end

    specify "the collection inherits permissions" do
      expect(collection).to have_permitted_actions_for(user, "self.read", "self.update", "collections.read", "collections.assets.read", "items.read")
    end

    specify "an item inherits permissions" do
      expect(item).to have_permitted_actions_for(user, "self.read", "self.update", "items.read")

      # it does not include collection permissions
      expect(item).not_to have_permitted_actions_for(user, "collections.read")
    end

    specify "a subitem inherits permissions" do
      expect(subitem).to have_permitted_actions_for(user, "self.read", "self.update", "items.assets.read")

      # it does not include collection permissions
      expect(subitem).not_to have_permitted_actions_for(user, "collections.read")
    end
  end

  context "when inheriting permissions from an item" do
    let!(:accessible) { item }

    specify "the parent community does not have any permissions" do
      expect(community).not_to have_permitted_actions_for(user, "self.read")
    end

    specify "the parent collection does not inherit permissions" do
      expect(collection).not_to have_permitted_actions_for(user, "self.read", "self.update", "collections.read", "collections.assets.read", "items.read")
    end

    specify "the item inherits permissions" do
      expect(item).to have_permitted_actions_for(user, "self.read", "self.update", "items.read")

      # it does not include collection permissions
      expect(item).not_to have_permitted_actions_for(user, "collections.read")
    end

    specify "a subitem inherits permissions" do
      expect(subitem).to have_permitted_actions_for(user, "self.read", "self.update", "items.assets.read")

      # it does not include collection permissions
      expect(subitem).not_to have_permitted_actions_for(user, "collections.read")
    end
  end
end
