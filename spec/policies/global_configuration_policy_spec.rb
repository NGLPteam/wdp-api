# frozen_string_literal: true

RSpec.describe GlobalConfigurationPolicy, type: :policy do
  let!(:user) { FactoryBot.create :user }

  let!(:record) { GlobalConfiguration.fetch }

  let!(:scope) { described_class::Scope.new(user, GlobalConfiguration.all) }

  subject { described_class }

  context "as an admin" do
    let!(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include record
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit user, record
      end
    end

    permissions :create? do
      it "is not allowed" do
        is_expected.not_to permit user, record
      end
    end

    permissions :update? do
      it "is allowed" do
        is_expected.to permit user, record
      end
    end

    permissions :destroy? do
      it "is not allowed" do
        is_expected.not_to permit user, record
      end
    end
  end

  context "as an anonymous user" do
    let(:user) { AnonymousUser.new }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include record
      end
    end

    permissions :show? do
      it "is allowed" do
        is_expected.to permit user, record
      end
    end

    permissions :create? do
      it "is not allowed" do
        is_expected.not_to permit user, record
      end
    end

    permissions :update? do
      it "is not allowed" do
        is_expected.not_to permit user, record
      end
    end

    permissions :destroy? do
      it "is not allowed" do
        is_expected.not_to permit user, record
      end
    end
  end
end
