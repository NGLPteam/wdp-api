# frozen_string_literal: true

RSpec.describe Schemas::Orderings::RefreshJob, type: :job do
  let!(:ordering) { FactoryBot.create :ordering }

  it_behaves_like "a pass-through operation job", "schemas.orderings.refresh" do
    let(:job_arg) { ordering }
  end
end
