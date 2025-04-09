# frozen_string_literal: true

RSpec.describe Users::SynchronizeAccessInfo, type: :operation do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  let_it_be(:anonymous_user) { AnonymousUser.new }

  it "works with a user" do
    expect_calling_with(user).to succeed.with(user)
  end

  it "quietly ignores non-users (e.g. anonymous ones)" do
    expect_calling_with(anonymous_user).to succeed.with(nil)
  end
end
