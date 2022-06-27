# frozen_string_literal: true

RSpec.describe Searching::Operators::ForType, type: :operation do
  it "returns the right operators by type", :aggregate_failures do
    expect_calling_with("boolean").to match_array %w[equals]
    expect_calling_with("date").to match_array %w[date_equals date_gte date_lte]
    expect_calling_with("timestamp").to match_array %w[date_equals date_gte date_lte]
    expect_calling_with("variable_date").to match_array %w[date_equals date_gte date_lte]
    expect_calling_with("markdown").to match_array %w[matches]
    expect_calling_with("full_text").to match_array %w[matches]
    expect_calling_with("string").to match_array %w[equals]
    expect_calling_with("select").to match_array %w[equals in_any]
    expect_calling_with("multiselect").to match_array %w[equals in_any]
    expect_calling_with("float").to match_array %w[equals numeric_gte numeric_lte]
    expect_calling_with("integer").to match_array %w[equals numeric_gte numeric_lte]
  end

  it "returns an empty array for an unknown type" do
    expect_calling_with("anything else").to eq []
  end
end
