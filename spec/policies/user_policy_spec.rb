# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:admin, refind: true) { FactoryBot.create :user, :admin }

  let_it_be(:manager, refind: true) { FactoryBot.create :user, manager_on: [community] }

  let_it_be(:editor, refind: true) { FactoryBot.create :user, editor_on: [community] }

  let_it_be(:reader, refind: true) { FactoryBot.create :user, reader_on: [community] }

  let_it_be(:regular_user, refind: true) { FactoryBot.create :user }

  let_it_be(:anonymous_user) { AnonymousUser.new }

  let_it_be(:other_users, refind: true) { FactoryBot.create_list :user, 2 }

  let_it_be(:other_user, refind: true) { other_users.first }

  let(:user) { regular_user }

  let!(:scope) { described_class::Scope.new(user, User.all) }

  subject { described_class }

  shared_examples "allowed generally" do
    it "is allowed generally" do
      is_expected.to permit user, other_user
    end
  end

  shared_examples "allowed on the self" do
    it "is allowed on the self" do
      is_expected.to permit(user, user)
    end
  end

  shared_examples "forbidden generally" do
    it "is forbidden generally" do
      is_expected.not_to permit user, other_user
    end
  end

  shared_examples "forbidden on the self" do
    it "is forbidden on the self" do
      is_expected.not_to permit(user, user)
    end
  end

  shared_examples_for "a full-access scope" do
    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include user, *other_users
      end
    end
  end

  shared_examples_for "a self-only scope" do
    permissions ".scope" do
      subject { scope.resolve }

      it "includes only the user" do
        is_expected.to contain_exactly user
      end
    end
  end

  context "as a user with admin access" do
    let!(:user) { admin }

    permissions :read?, :show? do
      include_examples "allowed generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "allowed generally"

      include_examples "allowed on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "allowed generally"

      include_examples "allowed on the self"
    end

    include_examples "a full-access scope"
  end

  context "as a user with manager access" do
    let!(:user) { manager }

    permissions :read?, :show? do
      include_examples "allowed generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    include_examples "a full-access scope"
  end

  context "as a user with editor access" do
    let!(:user) { editor }

    permissions :read?, :show? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    include_examples "a self-only scope"
  end

  context "as a user with reader access" do
    let!(:user) { reader }

    permissions :read?, :show? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    include_examples "a self-only scope"
  end

  context "as a user with no special access" do
    let!(:user) { regular_user }

    permissions :read?, :show? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    include_examples "a self-only scope"
  end

  context "as an anonymous user" do
    let!(:user) { anonymous_user }

    permissions :read?, :show? do
      include_examples "forbidden generally"

      include_examples "allowed on the self"
    end

    permissions :create? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :update? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :destroy? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions :reset_password? do
      include_examples "forbidden generally"

      include_examples "forbidden on the self"
    end

    permissions ".scope" do
      subject { scope.resolve }

      it { is_expected.to be_blank }
    end
  end
end
