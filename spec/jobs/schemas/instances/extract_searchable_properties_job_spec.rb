# frozen_string_literal: true

RSpec.describe Schemas::Instances::ExtractSearchablePropertiesJob, type: :job do
  let!(:instance) { FactoryBot.create :collection }

  it_behaves_like "a pass-through operation job", "schemas.instances.extract_searchable_properties" do
    let(:job_arg) { instance }
  end
end
