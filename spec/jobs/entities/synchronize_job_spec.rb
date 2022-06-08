# frozen_string_literal: true

RSpec.describe Entities::SynchronizeJob, type: :job do
  it_behaves_like "a pass-through operation job", "entities.sync" do
    let!(:job_arg) do
      FactoryBot.create :collection
    end
  end
end
