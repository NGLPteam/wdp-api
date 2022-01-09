# frozen_string_literal: true

RSpec.describe Schemas::Instances::PopulateOrderingsJob, type: :job do
  let!(:instance) { FactoryBot.create :collection }

  it_behaves_like "a pass-through operation job", "schemas.instances.populate_orderings" do
    let(:job_arg) { instance }
  end
end
