# frozen_string_literal: true

RSpec.describe Roles::CalculateSystemRoles, type: :operation do
  it "calculates the expected amount of roles" do
    expect_calling.to have(4).items
  end
end
