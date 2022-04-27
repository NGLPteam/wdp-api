# frozen_string_literal: true

RSpec.describe Seeding::ImportVendoredJob, type: :job do
  it_behaves_like "a pass-through operation job", "seeding.import_vendored" do
    let(:job_arg) { "some_name" }
  end
end
