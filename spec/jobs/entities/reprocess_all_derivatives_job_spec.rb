# frozen_string_literal: true

RSpec.describe Entities::ReprocessAllDerivativesJob, type: :job do
  let!(:community) { FactoryBot.create :community }
  let!(:collection) { FactoryBot.create :collection, community: community }

  it "enqueues the expected amount of subjobs" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::ReprocessDerivativesJob).twice
  end
end
