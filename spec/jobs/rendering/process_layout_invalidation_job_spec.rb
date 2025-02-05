# frozen_string_literal: true

RSpec.describe Rendering::ProcessLayoutInvalidationJob, type: :job do
  let_it_be(:entity, refind: true) { FactoryBot.create :community }

  let_it_be(:invalidations, refind: true) do
    3.times.map do
      FactoryBot.create(:layout_invalidation, entity:, stale_at: Faker::Time.backward)
    end
  end

  let_it_be(:layout_invalidation) do
    invalidations.max_by(&:stale_at)
  end

  before do
    LayoutInvalidation.excluding(invalidations).delete_all
  end

  context "when dealing with multiple invalidations for entities" do
    it "works as expected" do
      expect do
        described_class.perform_now(layout_invalidation)
      end.to change(LayoutInvalidation, :count).by(-3)
        .and change(Templates::HeroInstance, :count).by(1)
    end
  end
end
