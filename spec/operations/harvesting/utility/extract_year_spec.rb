# frozen_string_literal: true

RSpec.describe Harvesting::Utility::ExtractYear, type: :operation do
  it "handles a complex date description" do
    expect_calling_with("Fall/Winter 2011").to succeed.with(2011)
  end

  it "handles a simple year" do
    expect_calling_with("2022").to succeed.with(2022)
  end

  it "handles failures gracefully", :aggregate_failures do
    expect_calling_with(nil).to be_a_monadic_failure.with_key(:unknown_year)
    expect_calling_with("Some Input").to be_a_monadic_failure.with_key(:unknown_year)
  end
end
