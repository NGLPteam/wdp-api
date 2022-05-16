# frozen_string_literal: true

RSpec.describe Harvesting::Sources::CreateManualAttempt, type: :operation do
  let!(:harvest_source) { FactoryBot.create :harvest_source }
  let!(:target_entity) { FactoryBot.create :community }

  it "creates a harvest attempt" do
    expect do
      expect_calling_with(harvest_source, target_entity).to succeed.with(a_kind_of(HarvestAttempt))
    end.to change(HarvestAttempt, :count).by(1)
  end

  it "can create consecutive harvest attempts and update current/previous" do
    expect do
      expect_calling_with(harvest_source, target_entity).to succeed
    end.to change(HarvestAttempt.current, :count).by(1)

    expect do
      expect_calling_with(harvest_source, target_entity).to succeed
    end.to keep_the_same(HarvestAttempt.current, :count).and change(HarvestAttempt.previous, :count).by(1)
  end
end
