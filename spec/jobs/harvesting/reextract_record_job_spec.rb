# frozen_string_literal: true

RSpec.describe Harvesting::ReextractRecordJob, type: :job do
  let(:harvest_record) { FactoryBot.create :harvest_record }

  it_behaves_like "a pass-through operation job", "harvesting.actions.reextract_record" do
    let(:job_arg) { harvest_record }
  end
end
