# frozen_string_literal: true

RSpec.describe Harvesting::Schedules::Parse, type: :operation do
  it "accepts a valid cronish expression" do
    expect_calling_with("every 2 days at 4 pm").to succeed.with(include_json(mode: "scheduled"))
  end

  it "catches frequencies that happen too often" do
    expect_calling_with("every hour").to monad_fail.with([:invalid_frequency_expression, [:"frequency_expression.too_frequent"]])
  end

  it "catches invalid frequency expressions" do
    expect_calling_with("this will not parse").to monad_fail.with([:invalid_frequency_expression, [:"frequency_expression.invalid"]])
  end

  it "accepts empty / manual expressions", :aggregate_failures do
    expect_calling_with(nil).to succeed.with(include_json(mode: "manual"))
    expect_calling_with("").to succeed.with(include_json(mode: "manual"))
    expect_calling_with("   ").to succeed.with(include_json(mode: "manual"))
    expect_calling_with(" manual   ").to succeed.with(include_json(mode: "manual"))
  end
end
