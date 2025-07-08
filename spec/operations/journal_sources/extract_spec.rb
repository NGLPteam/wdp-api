# frozen_string_literal: true

RSpec.describe JournalSources::Extract, type: :operation do
  it "blows up with an unknown extraction type" do
    expect do
      operation.call(:unknown_thing)
    end.to raise_error NoMatchingPatternError
  end

  describe "#first_string" do
    it "handles an array" do
      expect_calling_with(:first_string, ["foo"]).to succeed.with("foo")
    end

    it "handles a string" do
      expect_calling_with(:first_string, "foo").to succeed.with("foo")
    end

    it "handles failures gracefully", :aggregate_failures do
      expect_calling_with(:first_string, nil).to be_a_monadic_failure
      expect_calling_with(:first_string, 2024).to be_a_monadic_failure
    end
  end

  describe "#pages" do
    it "handles an array of pages" do
      expect_calling_with(:pages, ["pages 222"]).to succeed.with(fpage: 222, lpage: nil)
    end

    it "handles page range" do
      expect_calling_with(:pages, "222–224").to succeed.with(fpage: 222, lpage: 224)
    end

    it "handles failures gracefully", :aggregate_failures do
      expect_calling_with(:pages, nil).to be_a_monadic_failure
      expect_calling_with(:pages, "not a page").to be_a_monadic_failure
    end
  end

  describe "#year" do
    it "handles a complex date description" do
      expect_calling_with(:year, ["Fall/Winter 2011"]).to succeed.with(2011)
    end

    it "handles a simple year" do
      expect_calling_with(:year, "2022").to succeed.with(2022)
    end

    it "handles failures gracefully", :aggregate_failures do
      expect_calling_with(:year, nil).to be_a_monadic_failure
      expect_calling_with(:year, "Some Input").to be_a_monadic_failure
    end
  end
end
