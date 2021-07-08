# frozen_string_literal: true

RSpec.describe AccessGrant, type: :model do
  let!(:accessible) { FactoryBot.create :community }

  let!(:role) { FactoryBot.create :role, :editor }

  let!(:user) { FactoryBot.create :user }

  it "creates granted permissions" do
    expect do
      FactoryBot.create :access_grant, accessible: accessible, role: role, subject: user
    end.to change(GrantedPermission, :count).by_at_least(1)
  end
end
