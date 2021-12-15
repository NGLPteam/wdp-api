# frozen_string_literal: true

RSpec.describe VariablePrecision::ParseDate, type: :operation do
  let!(:operation) { described_class.new }

  let!(:now) { Date.current }

  let!(:today) { VariablePrecisionDate.new now, :day }

  let!(:none) { VariablePrecisionDate.none }

  it "passes along an already-variable precision date" do
    expect_calling_with(today).to succeed.with(today)
  end

  it "supports a raw date" do
    expect_calling_with(Date.current).to succeed.with(today)
  end

  it "supports a raw datetime" do
    expect_calling_with(now.to_datetime).to succeed.with(today)
  end

  it "supports a raw time" do
    expect_calling_with(now.to_time).to succeed.with(today)
  end

  it "supports parsing a raw ISO8601-encoded date" do
    expect_calling_with(Date.current.to_s).to succeed.with(today)
  end

  it "parses a year as a string" do
    expect_calling_with("2004").to succeed.with(VariablePrecisionDate.from_year(2004))
  end

  it "parses a year as an integer" do
    expect_calling_with(2008).to succeed.with(VariablePrecisionDate.from_year(2008))
  end

  it "parses a year-month value" do
    expect_calling_with("2021.09").to succeed.with(VariablePrecisionDate.from_month(2021, 9))
  end

  it "swallows errors with an invalid date" do
    expect_calling_with("2021-10-55").to succeed.with(none)
  end

  it "handles blank values" do
    expect_calling_with(nil).to succeed.with(none)
  end

  it "handles unexpected or unknown values" do
    expect_calling_with("something unparseable").to succeed.with(none)
  end

  it "handles a hash representation" do
    expect_calling_with(value: now.to_s, precision: :day).to succeed.with(today)
  end

  it "handles the SQL representation" do
    expect_calling_with("(2021-05-01,month)").to succeed.with(VariablePrecisionDate.from_month(2021, 5))
  end

  it "handles the quoted SQL representation" do
    expect_calling_with(%[("2021-05-01","month")]).to succeed.with(VariablePrecisionDate.from_month(2021, 5))
  end
end
