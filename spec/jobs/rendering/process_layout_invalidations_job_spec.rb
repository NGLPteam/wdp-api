# frozen_string_literal: true

RSpec.describe Rendering::ProcessLayoutInvalidationsJob, type: :job do
  let_it_be(:community_1, refind: true) { FactoryBot.create :community }
  let_it_be(:community_2, refind: true) { FactoryBot.create :community }

  let_it_be(:invalidations, refind: true) do
    [community_1, community_2].flat_map do |entity|
      3.times.map do
        FactoryBot.create :layout_invalidation, entity:, stale_at: Faker::Time.backward
      end
    end
  end

  before do
    LayoutInvalidation.excluding(invalidations).delete_all
  end

  context "when dealing with multiple invalidations for entities" do
    it "works as expected" do
      expect do
        described_class.perform_now
      end.to have_enqueued_job(Rendering::ProcessLayoutInvalidationJob).twice
    end

    context "when rendering is serialized" do
      before do
        allow(MeruConfig).to receive(:serialize_rendering?).and_return(true)
      end

      it "evaluates immediately" do
        expect do
          described_class.perform_now
        end.to change(LayoutInvalidation, :count).by(-6)
      end
    end
  end
end
