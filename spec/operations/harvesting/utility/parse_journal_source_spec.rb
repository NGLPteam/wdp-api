# frozen_string_literal: true

RSpec.describe Harvesting::Utility::ParseJournalSource, type: :operation do
  context "with a well-structured citation" do
    let(:multiple_pages) do
      "Some Journal; Vol. 18 No. 5 (2022); 106-112"
    end

    let(:single_page) do
      "Some Journal; Vol. 5 No. 12 (2009); 3"
    end

    it "handles a range of pages" do
      expect_calling_with(multiple_pages).to have_attributes(volume: "18", issue: ?5, year: 2022, fpage: 106, lpage: 112)
    end

    it "handles a single page" do
      expect_calling_with(single_page).to have_attributes(volume: ?5, issue: "12", year: 2009, fpage: 3, lpage: nil)
    end
  end

  context "with a citation that specifies the season" do
    let(:input) do
      "Journal of Some Unknown Studies; Vol 6, No 2: Fall/Winter 2011"
    end

    it "parses correctly" do
      expect_calling_with(input).to have_attributes(volume: ?6, issue: ?2, year: 2011)
    end
  end

  context "with auto_create_volumes_and_issues set" do
    include Dry::Effects::Handler.Resolve

    around do |example|
      provide auto_create_volumes_and_issues: true do
        example.run
      end
    end

    it "defaults to volume 1 and issue 1" do
      expect_calling_with("literally anything").to have_attributes(volume: ?1, issue: ?1).and be_known
    end

    it "can handle just a volume" do
      expect_calling_with("Some Journal; Vol. 13 (1999)").to have_attributes(volume: "13", issue: ?1, year: 1999).and be_known
    end
  end

  it "handles a truncated format (such as used by CDL)" do
    expect_calling_with(nil, "Some Journal, vol 12, iss 103").to have_attributes(volume: "12", issue: "103", fpage: nil)
  end

  it "handles non-matching input" do
    expect_calling_with("some random text").to be_unknown
  end
end
