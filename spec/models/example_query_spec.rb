# frozen_string_literal: true

RSpec.describe ExampleQuery, type: :model do
  it "is formatted correctly" do
    expect do
      expect(described_class.count).to be > 0
    end.to execute_safely
  end
end
