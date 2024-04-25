# frozen_string_literal: true

RSpec.describe Seeding::ExportRoot, type: :operation do
  let!(:community) do
    FactoryBot.create(:community, identifier: "sample-community")
  end

  let!(:series) { FactoryBot.create :collection, community:, schema: "nglp:series" }
  let!(:unit) { FactoryBot.create :collection, community:, parent: series, schema: "nglp:unit" }

  it "can export a hierarchy" do
    expect_calling_with(communities: [community.identifier]).to succeed
  end
end
