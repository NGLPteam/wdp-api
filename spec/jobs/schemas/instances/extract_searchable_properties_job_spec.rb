# frozen_string_literal: true

RSpec.describe Schemas::Instances::ExtractSearchablePropertiesJob, type: :job do
  let!(:instance) { FactoryBot.create :collection }

  it_behaves_like "a pass-through operation job", "schemas.instances.extract_searchable_properties" do
    let(:job_arg) { instance }

    it "enqueues a job to re-extract composed texts" do
      expect_running_the_job.to have_enqueued_job(Schemas::Instances::ExtractComposedTextJob).once.with(instance)
    end
  end
end
