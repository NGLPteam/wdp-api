# frozen_string_literal: true

RSpec.describe Access::CalculateAllGrantedPermissionsJob, type: :job do
  let!(:access_grants) { FactoryBot.create_list :access_grant, 2 }

  it "enqueues a job to calculate missing permissions for each AccessGrant" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job.exactly(2).times
  end
end
