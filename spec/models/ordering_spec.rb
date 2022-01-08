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
end
