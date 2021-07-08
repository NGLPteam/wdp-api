# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  let!(:user) { FactoryBot.create :user }

  let!(:other_users) { FactoryBot.create_list :user, 2 }

  let!(:scope) { described_class::Scope.new(user, User.all) }

  subject { described_class }

  context "as a user with admin access" do
    let!(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include user, *other_users
      end
    end
  end

  context "as a user with users.* access" do
    let!(:user) { FactoryBot.create :user, :users_access }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include user, *other_users
      end
    end
  end

  context "as a user with no special access" do
    let!(:user) { FactoryBot.create :user }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes only the user" do
        is_expected.to contain_exactly user
      end
    end
  end

  context "as an anonymous user" do
    let!(:user) { AnonymousUser.new }

    permissions ".scope" do
      subject { scope.resolve }

      it { is_expected.to be_blank }
    end
  end
end
