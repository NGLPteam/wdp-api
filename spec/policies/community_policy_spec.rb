# frozen_string_literal: true

RSpec.describe CommunityPolicy, type: :policy do
  let!(:user) { FactoryBot.create :user }

  let!(:community) { FactoryBot.create :community }

  let!(:other_community) { FactoryBot.create :community }

  let!(:editor_role) { FactoryBot.create :role, :editor }

  let!(:scope) { described_class::Scope.new(user, Community.all) }

  subject { described_class }

  context "as a user with admin access" do
    let!(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include community, other_community
      end
    end

    permissions :read?, :show?, :update?, :destroy?, :create_items?, :create_collections? do
      it "is allowed" do
        is_expected.to permit(user, community)
      end

      it "is allowed on other communities" do
        is_expected.to permit(user, other_community)
      end
    end
  end

  context "as a user with communities.* access" do
    let!(:user) { FactoryBot.create :user, :communities_access }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include community, other_community
      end
    end

    permissions :read?, :show?, :update?, :destroy? do
      it "is allowed" do
        is_expected.to permit(user, community)
      end

      it "is allowed on other communities" do
        is_expected.to permit(user, other_community)
      end
    end

    permissions :create_items?, :create_collections? do
      it "is disallowed" do
        is_expected.not_to permit user, community
      end
    end
  end

  context "as a user with specifically-granted access to a community" do
    before do
      grant_access! editor_role, on: community, to: user
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "include what a user has access to" do
        is_expected.to include community
      end

      it "excludes what a user can't see" do
        is_expected.not_to include other_community
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit(user, community)
      end

      it "is allowed on other communities" do
        is_expected.to permit(user, other_community)
      end
    end

    permissions :read?, :update?, :destroy?, :create_items?, :create_collections? do
      it "is allowed" do
        is_expected.to permit(user, community)
      end

      it "is not allowed on other communities" do
        is_expected.not_to permit(user, other_community)
      end
    end

    permissions :create? do
      it "is not allowed" do
        is_expected.not_to permit(user, community)
      end
    end
  end

  context "as a user with no special access" do
    let!(:user) { FactoryBot.create :user }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes nothing" do
        is_expected.to be_blank
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit user, community
      end
    end

    permissions :read?, :create?, :update?, :destroy?, :create_items?, :create_collections? do
      it "is not allowed" do
        is_expected.not_to permit user, community
      end
    end
  end

  context "as an anonymous user" do
    let!(:user) { AnonymousUser.new }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes nothing" do
        is_expected.to be_blank
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit user, community
      end
    end

    permissions :read?, :create?, :update?, :destroy?, :create_items?, :create_collections? do
      it "is not allowed" do
        is_expected.not_to permit user, community
      end
    end
  end
end
