# frozen_string_literal: true

RSpec.describe StaleEntities::Process, type: :operation do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  context "with an existing entity" do
    let_it_be(:older_invalidation, refind: true) { FactoryBot.create :layout_invalidation, entity: community, stale_at: 15.minutes.ago }
    let_it_be(:recent_invalidation, refind: true) { FactoryBot.create :layout_invalidation, entity: community, stale_at: Time.current }

    let_it_be(:stale_entity, refind: true) { StaleEntity.find recent_invalidation.reload.sequence_id }

    before do
      LayoutInvalidation.excluding(older_invalidation, recent_invalidation).delete_all
    end

    it "re-renders and prunes" do
      expect do
        expect_calling_with(stale_entity).to succeed.with(:checked)
      end.to change(Layouts::MainInstance, :count).by(1)
        .and change(Templates::HeroInstance, :count).by(1)
        .and change(LayoutInvalidation, :count).by(-2)
        .and change(StaleEntity, :count).by(-1)

      expect do
        stale_entity.reload
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        recent_invalidation.reload
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        older_invalidation.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "when the entity can't be found" do
      before do
        allow(stale_entity).to receive(:entity).and_return(nil)
      end

      it "processes without issue" do
        expect do
          expect_calling_with(stale_entity).to succeed.with(:deleted)
        end.to keep_the_same(Layouts::MainInstance, :count)
          .and keep_the_same(Templates::HeroInstance, :count)
          .and change(LayoutInvalidation, :count).by(-2)
          .and change(StaleEntity, :count).by(-1)

        expect do
          stale_entity.reload
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the entity is deleted mid-request" do
      before do
        stale_entity

        # delete out-of-bounds with sanity check
        expect do
          Community.delete community.id
        end.to change(Community, :count).by(-1)
      end

      it "processes without issue" do
        expect do
          expect_calling_with(stale_entity).to succeed.with(:deleted)
        end.to keep_the_same(Layouts::MainInstance, :count)
          .and keep_the_same(Templates::HeroInstance, :count)
          .and change(LayoutInvalidation, :count).by(-2)
          .and change(StaleEntity, :count).by(-1)

        expect do
          stale_entity.reload
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "when an entity has been deleted" do
    let_it_be(:layout_invalidation, refind: true) { FactoryBot.create :layout_invalidation, :missing_entity }

    let_it_be(:stale_entity, refind: true) { StaleEntity.find layout_invalidation.reload.sequence_id }

    it "processes without issue" do
      expect do
        expect_calling_with(stale_entity).to succeed.with(:deleted)
      end.to keep_the_same(Layouts::MainInstance, :count)
        .and keep_the_same(Templates::HeroInstance, :count)
        .and change(LayoutInvalidation, :count).by(-1)
        .and change(StaleEntity, :count).by(-1)

      expect do
        layout_invalidation.reload
      end.to raise_error ActiveRecord::RecordNotFound

      expect do
        stale_entity.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
