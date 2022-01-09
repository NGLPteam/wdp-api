# frozen_string_literal: true

RSpec.describe Entities::SynchronizeAllJob, type: :job do
  it "enqueues a job for synchronizing communities" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::SynchronizeCommunitiesJob).once
  end

  it "enqueues a job for synchronizing collections" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::SynchronizeCollectionsJob).once
  end

  it "enqueues a job for synchronizing entity links" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::SynchronizeEntityLinksJob).once
  end

  it "enqueues a job for synchronizing items" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::SynchronizeItemsJob).once
  end
end
