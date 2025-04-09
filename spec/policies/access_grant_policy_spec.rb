# frozen_string_literal: true

RSpec.describe AccessGrantPolicy, type: :policy do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:admin, refind: true) { FactoryBot.create :user, :admin }

  let_it_be(:manager, refind: true) { FactoryBot.create :user, manager_on: [community] }

  let_it_be(:editor, refind: true) { FactoryBot.create :user, editor_on: [community] }

  let_it_be(:regular_user, refind: true) { FactoryBot.create :user }

  let_it_be(:anonymous_user) { AnonymousUser.new }

  let_it_be(:admin_access_grant, refind: true) { admin.access_grants.where(accessible: community, role: Role.fetch(:admin)).first! }

  let_it_be(:manager_access_grant, refind: true) { manager.access_grants.where(role: Role.fetch(:manager)).first! }

  let_it_be(:editor_access_grant, refind: true) { editor.access_grants.where(role: Role.fetch(:editor)).first! }

  let_it_be(:other_access_grant, refind: true) { FactoryBot.create :access_grant }

  let(:access_grant) { editor_access_grant }

  let(:user) { regular_user }

  let!(:scope) { described_class::Scope.new(user, AccessGrant.all) }

  subject { described_class }

  shared_examples_for "forbidden for all grants" do
    it "is forbidden on all admin access grants" do
      is_expected.not_to permit(user, editor_access_grant)
    end

    it "is forbidden on all manager access grants" do
      is_expected.not_to permit(user, editor_access_grant)
    end

    it "is forbidden on all editor access grants" do
      is_expected.not_to permit(user, editor_access_grant)
    end
  end

  shared_examples_for "not updatable" do
    permissions :update?, :manage_access? do
      include_examples "forbidden for all grants"
    end
  end

  shared_examples_for "inaccessible" do
    permissions :read?, :show?, :create?, :update?, :destroy?, :manage_access? do
      include_examples "forbidden for all grants"
    end

    permissions :destroy? do
      it "is forbidden on admin access grants" do
        is_expected.not_to permit(user, admin_access_grant)
      end
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "contains nothing" do
        is_expected.to be_blank
      end
    end
  end

  context "as a user with admin access" do
    let!(:user) { admin }

    include_examples "not updatable"

    permissions :read?, :show? do
      it "is allowed on manager grants" do
        is_expected.to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions :create? do
      it "is forbidden on admin access grants" do
        is_expected.not_to permit(user, admin_access_grant)
      end

      it "is allowed for manager grants" do
        is_expected.to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions :destroy? do
      it "is forbidden on admin access grants" do
        is_expected.not_to permit(user, admin_access_grant)
      end

      it "is allowed on manager grants" do
        is_expected.to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "contains everything" do
        is_expected.to match_array AccessGrant.all.to_a
      end
    end
  end

  context "as a user with manager access" do
    let!(:user) { manager }

    include_examples "not updatable"

    permissions :read?, :show? do
      it "is allowed on manager grants" do
        is_expected.to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions :create? do
      it "is forbidden on admin access grants" do
        is_expected.not_to permit(user, admin_access_grant)
      end

      it "is forbidden for self grants" do
        is_expected.not_to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions :destroy? do
      it "is forbidden on admin access grants" do
        is_expected.not_to permit(user, admin_access_grant)
      end

      it "is forbidden for one's own manager role" do
        is_expected.not_to permit(user, manager_access_grant)
      end

      it "is allowed on editor grants" do
        is_expected.to permit(user, editor_access_grant)
      end
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "includes its own grant" do
        is_expected.to include manager_access_grant
      end

      it "includes an editor grant" do
        is_expected.to include editor_access_grant
      end

      it "excludes other grants" do
        is_expected.to exclude other_access_grant
      end
    end
  end

  context "as a user with editor access" do
    let!(:user) { editor }

    include_examples "inaccessible"
  end

  context "as a user with no special access" do
    let!(:user) { regular_user }

    include_examples "inaccessible"
  end

  context "as an anonymous user" do
    let!(:user) { anonymous_user }

    include_examples "inaccessible"
  end
end
