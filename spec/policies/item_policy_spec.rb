# frozen_string_literal: true

RSpec.describe ItemPolicy, type: :policy do
  let!(:user) { FactoryBot.create :user }

  let!(:item) { FactoryBot.create :item }

  let!(:subitem) { FactoryBot.create :item, parent: item }

  let!(:other_item) { FactoryBot.create :item }

  let!(:contextual_role) { FactoryBot.create :role, :all_contextual }

  let!(:scope) { described_class::Scope.new(user, Item.all) }

  subject { described_class }

  context "as an admin" do
    let!(:user) { FactoryBot.create :user, :admin }

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
      subject { scope.resolve }

      it "includes what the user has read access to" do
        is_expected.to include item, subitem
      end

      it "excludes what a user can't see" do
        is_expected.not_to include other_item
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
    permissions ".scope" do
      subject { scope.resolve }

      it "is empty" do
        is_expected.to be_blank
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
    let(:user) { AnonymousUser.new }

    permissions ".scope" do
      subject { scope.resolve }

      it "is empty" do
        is_expected.to be_blank
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
