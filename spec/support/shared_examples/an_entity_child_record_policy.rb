# frozen_string_literal: true

RSpec.shared_examples_for "an entity child record policy" do
  let!(:entity) { FactoryBot.create :collection }

  let!(:user) { FactoryBot.create :user }

  let!(:entity) { FactoryBot.create :collection }

  let!(:record) { FactoryBot.create :record, entity: }

  let!(:editor_role) { FactoryBot.create :role, :editor }

  let!(:scope) { described_class::Scope.new(user, record.class.all) }

  subject { described_class }

  context "as an admin" do
    let!(:user) { FactoryBot.create :user, :admin }

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include record
      end
    end

    permissions :show?, :read?, :create?, :update?, :destroy? do
      it "is allowed" do
        is_expected.to permit(user, record)
      end
    end

    context "when the entity is a community" do
      let(:entity) { FactoryBot.create :community }

      permissions :show? do
        it "is allowed" do
          is_expected.to permit(user, record)
        end
      end
    end

    context "when the entity is hidden" do
      let(:entity) { FactoryBot.create :collection, :hidden }

      permissions :show? do
        it "is allowed" do
          is_expected.to permit(user, record)
        end
      end
    end
  end

  context "as a user with all contextual permissions" do
    before do
      grant_access! editor_role, on: entity, to: user
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to include record
      end
    end

    permissions :show?, :read?, :create?, :update?, :destroy? do
      it "is allowed" do
        is_expected.to permit(user, record)
      end
    end

    context "when the entity is a community" do
      let(:entity) { FactoryBot.create :community }

      permissions :show? do
        it "is allowed" do
          is_expected.to permit(user, record)
        end
      end
    end

    context "when the entity is hidden" do
      let(:entity) { FactoryBot.create :collection, :hidden }

      permissions :show? do
        it "is allowed" do
          is_expected.to permit(user, record)
        end
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
        is_expected.to permit(user, record)
      end
    end

    permissions :read?, :create?, :update?, :destroy? do
      it "is disallowed" do
        is_expected.not_to permit(user, record)
      end
    end

    context "when the entity is a community" do
      let(:entity) { FactoryBot.create :community }

      permissions :show? do
        it "is allowed" do
          is_expected.to permit(user, record)
        end
      end
    end

    context "when the entity is hidden" do
      let(:entity) { FactoryBot.create :collection, :hidden }

      permissions :show? do
        it "is disallowed" do
          is_expected.not_to permit(user, record)
        end
      end
    end
  end
end
