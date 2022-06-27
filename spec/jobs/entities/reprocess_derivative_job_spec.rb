# frozen_string_literal: true

RSpec.describe Entities::ReprocessDerivativeJob, type: :job do
  include ActiveJob::TestHelper

  let_it_be(:community) do
    perform_enqueued_jobs do
      FactoryBot.create :community, :with_thumbnail
    end.tap(&:reload)
  end

  it "works with an existing attachment" do
    expect(community.thumbnail_attacher).to be_stored

    expect do
      described_class.perform_now community, :thumbnail
    end.to execute_safely
  end

  it "works with a missing attachment" do
    expect do
      described_class.perform_now community, :hero_image
    end.to execute_safely
  end
end
