# frozen_string_literal: true

RSpec.describe Entities::ReprocessDerivativesJob, type: :job do
  include ActiveJob::TestHelper

  let!(:community) { FactoryBot.create :community }
  let!(:collection) { FactoryBot.create :collection, community: }

  it "enqueues the expected amount of subjobs for a community" do
    expect do
      described_class.perform_now community
    end.to have_enqueued_job(Entities::ReprocessDerivativeJob).exactly(3).times
  end

  it "enqueues the expected amount of subjobs for a collection" do
    expect do
      described_class.perform_now collection
    end.to have_enqueued_job(Entities::ReprocessDerivativeJob).twice
  end
end
