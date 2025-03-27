# frozen_string_literal: true

RSpec.describe CommunityPolicy, type: :policy do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  let_it_be(:community, refind: true) { FactoryBot.create :community, title: "Community" }

  let_it_be(:other_community, refind: true) { FactoryBot.create :community, title: "Other Community" }

  let_it_be(:manager_role, refind: true) { Role.fetch :manager }

  let!(:scope) { described_class::Scope.new(user, Community.all) }

  subject { described_class }

  context "as a user with admin access" do
    let_it_be(:user) { FactoryBot.create :user, :admin }

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

  context "as a user with specifically-granted manager access to a community" do
    before do
      grant_access! manager_role, on: community, to: user
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include community, other_community
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

    permissions :read?, :update?, :create_items?, :create_collections? do
      it "is allowed" do
        is_expected.to permit(user, community)
      end

      it "is not allowed on other communities" do
        is_expected.not_to permit(user, other_community)
      end
    end

    permissions :destroy? do
      it "is not allowed" do
        is_expected.not_to permit(user, community)
      end
    end

    permissions :create? do
      it "is not allowed" do
        is_expected.not_to permit(user, community)
      end
    end
  end

  context "as a user with no special access" do
    let_it_be(:user) { FactoryBot.create :user }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes all communities" do
        is_expected.to include(community, other_community)
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
    let_it_be(:user) { AnonymousUser.new }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes all communities" do
        is_expected.to include(community, other_community)
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
