# frozen_string_literal: true

RSpec.describe Entities::SyncHierarchiesJob, type: :job do
  it_behaves_like "a pass-through operation job", "entities.sync_hierarchies" do
    let!(:job_arg) do
      FactoryBot.create :collection
    end
  end
end
