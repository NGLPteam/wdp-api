# frozen_string_literal: true

RSpec.describe Entities::CalculateAuthorizing, type: :operation do
  let!(:item) { FactoryBot.create :item }

  it "works with an auth path" do
    expect_calling_with(auth_path: item.entity_auth_path).to succeed
  end

  it "works with a source" do
    expect_calling_with(source: item).to succeed
  end

  it "works with no args" do
    expect_calling.to succeed
  end

  it "works with stale: false" do
    expect_calling_with(stale: false).to succeed
  end
end
