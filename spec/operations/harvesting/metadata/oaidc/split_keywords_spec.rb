# frozen_string_literal: true

RSpec.describe Harvesting::Metadata::OAIDC::SplitKeywords, type: :operation do
  it "handles nil" do
    expect_calling_with(nil).to eq []
  end

  it "handles a mixed array of inputs" do
    expect_calling_with([%[foo, bar , baz], nil, "quux", [nil, :bloop]]).to eq %w[foo bar baz quux bloop]
  end

  it "handles a single string" do
    expect_calling_with("foo").to eq %w[foo]
  end
end
