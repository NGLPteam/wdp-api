# frozen_string_literal: true

RSpec.describe Schemas::Instances::RandomizeDefaultItemsJob, type: :job do
  let!(:items) { FactoryBot.create_list :item, 3 }

  let!(:article) { FactoryBot.create :item }

  before do
    FactoryBot.create_list :contributor, 5, :person

    article.alter_and_generate!("nglp:article")
  end

  it "enqueues the right number of jobs" do
    expect(Item.count).to eq 4

    expect do
      described_class.perform_now
    end.to have_enqueued_job(Schemas::Instances::AlterAndGenerateJob).exactly(3).times
  end
end
