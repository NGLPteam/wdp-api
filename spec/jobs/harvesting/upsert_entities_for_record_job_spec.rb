# frozen_string_literal: true

RSpec.describe Harvesting::UpsertEntitiesForRecordJob, type: :job do
  let(:harvest_record) { FactoryBot.create :harvest_record }

  it_behaves_like "a pass-through operation job", "harvesting.actions.upsert_entities" do
    let(:job_arg) { harvest_record }
    let(:operation_args) { [harvest_record, { reprepare: false }] }
  end
end
