# frozen_string_literal: true

RSpec.describe ItemPolicy, type: :policy do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  let_it_be(:item, refind: true) { FactoryBot.create :item, title: "Item" }

  let_it_be(:subitem, refind: true) { FactoryBot.create :item, parent: item, title: "Subitem" }

  let_it_be(:other_item, refind: true) { FactoryBot.create :item, title: "Other Item" }

  let_it_be(:contextual_role) { FactoryBot.create :role, :all_contextual }

  let!(:scope) { described_class::Scope.new(user, Item.all) }

  subject { described_class }

  context "as an admin" do
    let_it_be(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include item, subitem, other_item
      end
    end

    permissions :show?, :create?, :update?, :destroy? do
      it "is allowed on an item" do
        is_expected.to permit(user, item)
      end

      it "is allowed on a subitem" do
        is_expected.to permit(user, subitem)
      end
    end

    permissions :create_items?, :create_items? do
      it "is allowed on an item" do
        is_expected.to permit(user, item)
      end

      it "is allowed on a subitem" do
        is_expected.to permit(user, subitem)
      end
    end
  end

  context "as a user with all contextual permissions" do
    before do
      grant_access! contextual_role, on: item, to: user
    end

    permissions ".scope" do
      before do
        other_item.update!(visibility: :hidden)
      end

      subject { scope.resolve }

      it "excludes hidden records" do
        is_expected.to exclude(other_item).and include(item, subitem)
      end
    end

    permissions :show?, :create?, :update?, :destroy? do
      it "is allowed on an item" do
        is_expected.to permit(user, item)
      end

      it "is allowed on a subitem" do
        is_expected.to permit(user, subitem)
      end
    end

    permissions :manage_access? do
      it "is not allowed" do
        is_expected.not_to permit(user, item)
      end
    end

    permissions :create_items? do
      it "is allowed on an item" do
        is_expected.to permit(user, item)
      end

      it "is allowed on a subitem" do
        is_expected.to permit(user, subitem)
      end
    end
  end

  context "as a random user with no permissions" do
    let_it_be(:user) { FactoryBot.create :user }

    permissions ".scope" do
      before do
        other_item.update!(visibility: :hidden)
      end

      subject { scope.resolve }

      it "excludes hidden records" do
        is_expected.to exclude(other_item).and include(item, subitem)
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit(user, item)
      end
    end

    permissions :create?, :update?, :destroy? do
      it "is not allowed" do
        is_expected.not_to permit(user, item)
      end
    end

    context "when the item is hidden" do
      let(:item) { FactoryBot.create :item, :hidden }

      permissions :show? do
        it "is disallowed" do
          is_expected.not_to permit user, item
        end
      end
    end
  end

  context "as an anonymous user" do
    let_it_be(:user) { AnonymousUser.new }

    permissions ".scope" do
      before do
        other_item.update!(visibility: :hidden)
      end

      subject { scope.resolve }

      it "excludes hidden records" do
        is_expected.to exclude(other_item).and include(item, subitem)
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit(user, item)
      end
    end

    permissions :read?, :create?, :update?, :destroy? do
      it "is not allowed" do
        is_expected.not_to permit(user, item)
      end
    end

    context "when the item is hidden" do
      let(:item) { FactoryBot.create :item, :hidden }

      permissions :show? do
        it "is disallowed" do
          is_expected.not_to permit user, item
        end
      end
    end
  end
end
