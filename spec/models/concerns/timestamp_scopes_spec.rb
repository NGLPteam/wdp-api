# frozen_string_literal: true

RSpec.describe TimestampScopes do
  let_it_be(:expected_models) do
    ApplicationRecord.descendants.select { "created_at".in?(_1.column_names) && "updated_at".in?(_1.column_names) && _1.model_name.to_s.present? rescue false }.sort_by { _1.model_name.to_s }
  end

  it "is implemented on every class it should be", :aggregate_failures do
    expect(expected_models).to all(include_concern(described_class))
  end
end
