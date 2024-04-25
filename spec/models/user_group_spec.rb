# frozen_string_literal: true

RSpec.describe UserGroup, type: :model do
  let!(:user) { FactoryBot.create :user }

  let!(:user_group) { FactoryBot.create :user_group }

  let!(:user_group_membership) { FactoryBot.create :user_group_membership, user:, user_group: }

  it "can contain a user" do
    expect(user_group.users).to include user
  end
end
