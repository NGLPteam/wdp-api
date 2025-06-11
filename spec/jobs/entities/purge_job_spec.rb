# frozen_string_literal: true

RSpec.describe Entities::PurgeJob, type: :job do
  let_it_be(:community) { FactoryBot.create :community }

  it_behaves_like "a pass-through operation job", "entities.purge" do
    let(:job_arg) { community }
  end
end
