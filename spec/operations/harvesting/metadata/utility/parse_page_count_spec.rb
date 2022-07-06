# frozen_string_literal: true

RSpec.describe Harvesting::Metadata::Utility::ParsePageCount, type: :operation do
  it "handles nil" do
    expect_calling_with(nil).to be_nil
  end

  it "handles a tuple of fpage and lpage" do
    expect_calling_with([3, 5]).to eq 2
  end

  it "handles a mismatched tuple" do
    expect_calling_with([5, 3]).to eq 1
  end

  it "handles only an fpage" do
    expect_calling_with([3, nil]).to eq 1
  end
end
