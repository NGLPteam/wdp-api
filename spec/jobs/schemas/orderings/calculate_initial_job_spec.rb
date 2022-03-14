# frozen_string_literal: true

RSpec.describe Schemas::Orderings::CalculateInitialJob, type: :job do
  context "globally" do
    it_behaves_like "a void operation job", "schemas.orderings.calculate_initial"
  end

  context "for a specific entity" do
    let!(:collection) { FactoryBot.create :collection }

    it_behaves_like "a pass-through operation job", "schemas.orderings.calculate_initial" do
      let(:job_arg) { { entity: collection } }
    end
  end
end
