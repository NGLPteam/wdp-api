# frozen_string_literal: true

RSpec.describe Harvesting::Metadata::JATS::ParseSortableNumber, type: :operation do
  it "handles a single integer" do
    expect_calling_with(45).to be 45
  end

  it "handles 'SE'" do
    expect_calling_with("SE").to eq 0
  end

  it "handles an integral string" do
    expect_calling_with(?3).to be 3
  end

  it "can scan for an integer" do
    expect_calling_with("Issue 5 page 3").to eq 5
  end

  it "handles oddly-formatted numerals", :aggregate_failures do
    expect_calling_with("2/3").to eq 2
    expect_calling_with("3-4").to eq 3
  end

  it "has a fallback value" do
    expect_calling_with(:invalid).to eq(-1)
  end
end
