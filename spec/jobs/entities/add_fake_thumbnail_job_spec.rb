# frozen_string_literal: true

RSpec.describe Entities::AddFakeThumbnailJob, type: :job do
  include_context "stubs lorempixel"

  let!(:collection) { FactoryBot.create :collection }

  it "works with an Entity" do
    expect do
      described_class.perform_now collection.entity
    end.to have_enqueued_job
  end

  it "works with a HierarchicalEntity" do
    expect do
      described_class.perform_now collection
    end.to have_enqueued_job
  end

  it "fails silently with anything else" do
    user = FactoryBot.create :user

    expect do
      described_class.perform_now user
    end.not_to have_enqueued_job
  end
end
