# frozen_string_literal: true

RSpec.describe Harvesting::Dispatch::BuildMiddlewareState, type: :operation do
  it "supports a harvest attempt" do
    expect_calling_with(FactoryBot.create(:harvest_attempt)).to succeed
  end

  it "supports a harvest entity" do
    expect_calling_with(FactoryBot.create(:harvest_entity)).to succeed
  end

  it "supports a harvest mapping" do
    expect_calling_with(FactoryBot.create(:harvest_mapping)).to succeed
  end

  it "supports a harvest record" do
    expect_calling_with(FactoryBot.create(:harvest_record)).to succeed
  end

  it "supports a harvest source" do
    expect_calling_with(FactoryBot.create(:harvest_source)).to succeed
  end

  it "fails with anything else" do
    expect_calling_with(double(:unsupported)).to be_a_monadic_failure.with_key(:unknown_origin)
  end
end
