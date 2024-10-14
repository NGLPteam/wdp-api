# frozen_string_literal: true

RSpec.describe LayoutInvalidations::Process, type: :operation do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  context "with an existing entity" do
    let_it_be(:older_invalidation, refind: true) { FactoryBot.create :layout_invalidation, entity: community, stale_at: 15.minutes.ago }
    let_it_be(:recent_invalidation, refind: true) { FactoryBot.create :layout_invalidation, entity: community, stale_at: Time.current }

    before do
      LayoutInvalidation.excluding(older_invalidation, recent_invalidation).delete_all
    end

    it "re-renders and prunes" do
      expect do
        expect_calling_with(recent_invalidation).to succeed
      end.to change(Layouts::MainInstance, :count).by(1)
        .and change(Templates::HeroInstance, :count).by(1)
        .and change(LayoutInvalidation, :count).by(-2)

      expect do
        recent_invalidation.reload
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        older_invalidation.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not prune newer invalidations" do
      expect do
        expect_calling_with(older_invalidation).to succeed
      end.to change(Layouts::MainInstance, :count).by(1)
        .and change(Templates::HeroInstance, :count).by(1)
        .and change(LayoutInvalidation, :count).by(-1)

      expect do
        recent_invalidation.reload
      end.to execute_safely

      expect do
        older_invalidation.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when an entity has been deleted" do
    let_it_be(:layout_invalidation, refind: true) { FactoryBot.create :layout_invalidation, :missing_entity }

    it "works without issue" do
      expect do
        expect_calling_with(layout_invalidation).to succeed
      end.to keep_the_same(Layouts::MainInstance, :count)
        .and keep_the_same(Templates::HeroInstance, :count)
        .and change(LayoutInvalidation, :count).by(-1)

      expect do
        layout_invalidation.reload
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
