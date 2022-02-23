# frozen_string_literal: true

RSpec.describe Community, type: :model do
  it_behaves_like "an entity with a reference"

  describe "#grant_system_roles!" do
    let!(:administrator) { FactoryBot.create :user, :admin }

    specify "creating a community assigns an admin role to all existing admins" do
      expect do
        FactoryBot.create :community
      end.to change(AccessGrant, :count).by(1).and change { administrator.access_grants.admin.count }.by(1)
    end
  end
end
