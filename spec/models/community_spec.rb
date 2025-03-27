# frozen_string_literal: true

RSpec.describe Community, type: :model do
  it_behaves_like "an entity with a reference"

  let_it_be(:community, refind: true) { FactoryBot.create :community }

  subject { community }

  it { is_expected.to be_currently_visible }

  describe "#grant_system_roles!" do
    let!(:administrator) { FactoryBot.create :user, :admin }

    specify "creating a community assigns an admin role to all existing admins" do
      expect do
        FactoryBot.create :community
      end.to change(AccessGrant.where(user: administrator), :count).by(1).and change { administrator.access_grants.admin.count }.by(1)
    end
  end
end
