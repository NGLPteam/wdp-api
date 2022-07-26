# frozen_string_literal: true

RSpec.describe Ordering, type: :model, simple_v1_hierarchy: true, orderings: true do
  context "with an inherited ordering" do
    let!(:collection) { create_v1_collection }

    let!(:ordering) { collection.ordering! "items" }

    it "is no longer pristine when the definition is modified" do
      expect do
        set_ordering_paths! ordering, "entity.title"
      end.to change(ordering, :pristine).from(true).to(false)
    end
  end

  context "when working with an initially-selected ordering" do
    let!(:collection) { FactoryBot.create :collection }
    let!(:item) { FactoryBot.create :item, collection: collection }
    let!(:ordering_1) { FactoryBot.create :ordering, entity: collection }
    let!(:ordering_2) { FactoryBot.create :ordering, entity: collection }

    before do
      collection.select_initial_ordering!(ordering_1)
    end

    it "will properly refresh the initial selection when disabled" do
      expect do
        ordering_1.disable!
      end.to change { collection.reload_initial_ordering_link&.ordering_id }.from(ordering_1.id).to(ordering_2.id)

      expect do
        ordering_2.disable!
      end.to change { collection.reload_initial_ordering_link&.ordering_id }.from(ordering_2.id).to(nil)

      expect do
        ordering_1.enable!
      end.to change { collection.reload_initial_ordering_link&.ordering_id }.from(nil).to(ordering_1.id)
    end

    it "will properly refresh the initial selection when destroyed" do
      expect do
        ordering_1.destroy!
      end.to change { collection.reload_initial_ordering_link&.ordering_id }.from(ordering_1.id).to(ordering_2.id)

      expect do
        ordering_2.destroy!
      end.to change { collection.reload_initial_ordering_link&.ordering_id }.from(ordering_2.id).to(nil)
    end
  end
end
