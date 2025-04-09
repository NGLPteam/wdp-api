# frozen_string_literal: true

RSpec.describe Users::SynchronizeAllAccessInfo, type: :operation do
  let_it_be(:users) { FactoryBot.create_list :user, 3 }

  it "recalculates access info for all users" do
    expect_calling.to succeed.with(User.count)
  end
end
