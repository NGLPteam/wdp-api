# frozen_string_literal: true

RSpec.describe Seeding::ImportVendored, type: :operation do
  it "fails with an unknown vendor seed" do
    expect_calling_with("unknown-vendor").to be_a_monadic_failure
  end
end
