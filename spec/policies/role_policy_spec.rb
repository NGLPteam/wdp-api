# frozen_string_literal: true

RSpec.describe RolePolicy, type: :policy do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:admin, refind: true) { FactoryBot.create :user, :admin }

  let_it_be(:manager, refind: true) { FactoryBot.create :user, manager_on: [community] }

  let_it_be(:editor, refind: true) { FactoryBot.create :user, editor_on: [community] }

  let_it_be(:reader, refind: true) { FactoryBot.create :user, reader_on: [community] }

  let_it_be(:regular_user, refind: true) { FactoryBot.create :user }

  let_it_be(:anonymous_user) { AnonymousUser.new }

  let_it_be(:role_admin, refind: true) { Role.fetch(:admin) }

  let_it_be(:role_manager, refind: true) { Role.fetch(:manager) }

  let_it_be(:role_editor, refind: true) { Role.fetch(:editor) }

  let_it_be(:role_reader, refind: true) { Role.fetch(:reader) }

  let_it_be(:role_custom, refind: true) do
    FactoryBot.create :role, name: "AA", custom_priority: 100
  end

  let(:user) { regular_user }

  let!(:scope) { described_class::Scope.new(user, Role.all) }

  subject { described_class }

  before do
    AssignableRoleTarget.refresh!
  end

  shared_examples_for "allowed for custom roles" do
    it "is allowed for custom roles" do
      is_expected.to permit(user, role_custom)
    end
  end

  shared_examples_for "allowed for system roles" do
    it "is allowed for system roles", :aggregate_failures do
      is_expected.to permit(user, role_admin)
      is_expected.to permit(user, role_manager)
      is_expected.to permit(user, role_editor)
      is_expected.to permit(user, role_reader)
    end
  end

  shared_examples_for "forbidden for custom roles" do
    it "is forbidden for custom roles" do
      is_expected.not_to permit(user, role_custom)
    end
  end

  shared_examples_for "forbidden for system roles" do
    it "is forbidden for system roles", :aggregate_failures do
      is_expected.not_to permit(user, role_admin)
      is_expected.not_to permit(user, role_manager)
      is_expected.not_to permit(user, role_editor)
      is_expected.not_to permit(user, role_reader)
    end
  end

  shared_examples_for "common permissions" do
    permissions :show? do
      it "is always allowed", :aggregate_failures do
        is_expected.to permit(user, role_admin)
        is_expected.to permit(user, role_manager)
        is_expected.to permit(user, role_editor)
        is_expected.to permit(user, role_reader)
        is_expected.to permit(user, role_custom)
      end
    end

    permissions ".scope" do
      subject { scope.resolve }

      it "includes everything" do
        is_expected.to match_array Role.all.to_a
      end
    end
  end

  context "as a user with admin access" do
    let!(:user) { admin }

    include_examples "common permissions"

    permissions :read? do
      include_examples "allowed for custom roles"

      include_examples "allowed for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "allowed for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      it "is forbidden for admin roles" do
        is_expected.not_to permit(user, role_admin)
      end

      it "is allowed on manager roles" do
        is_expected.to permit(user, role_manager)
      end

      it "is allowed on editor roles" do
        is_expected.to permit(user, role_editor)
      end

      it "is allowed on reader roles" do
        is_expected.to permit(user, role_reader)
      end

      include_examples "allowed for custom roles"
    end
  end

  context "as a user with manager access" do
    let!(:user) { manager }

    include_examples "common permissions"

    permissions :read? do
      include_examples "allowed for custom roles"

      include_examples "allowed for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      it "is forbidden for admin roles" do
        is_expected.not_to permit(user, role_admin)
      end

      it "is forbidden on manager roles" do
        is_expected.not_to permit(user, role_manager)
      end

      it "is allowed on editor roles" do
        is_expected.to permit(user, role_editor)
      end

      it "is allowed on reader roles" do
        is_expected.to permit(user, role_reader)
      end

      include_examples "allowed for custom roles"
    end
  end

  context "as a user with editor access" do
    let!(:user) { editor }

    include_examples "common permissions"

    permissions :read? do
      include_examples "allowed for custom roles"

      include_examples "allowed for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end
  end

  context "as a user with reader access" do
    let!(:user) { reader }

    include_examples "common permissions"

    permissions :read? do
      include_examples "allowed for custom roles"

      include_examples "allowed for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end
  end

  context "as a user with no special access" do
    let!(:user) { regular_user }

    include_examples "common permissions"

    permissions :read? do
      include_examples "allowed for custom roles"

      include_examples "allowed for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end
  end

  context "as an anonymous user" do
    let!(:user) { anonymous_user }

    include_examples "common permissions"

    permissions :read? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :create?, :update?, :destroy? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end

    permissions :assign? do
      include_examples "forbidden for custom roles"

      include_examples "forbidden for system roles"
    end
  end
end
