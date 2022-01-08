# frozen_string_literal: true

RSpec.describe Schemas::Orderings::Reset, type: :operation, simple_v1_hierarchy: true, orderings: true do
  let!(:collection) { create_v1_collection }

  let!(:ordering) { collection.ordering! "items" }

  before do
    allow(ordering).to receive(:refresh).and_return(Dry::Monads.Success())
  end

  # We have had an issue in the past because of how we override `==`
  # to simplify uniqueness checking inside of arrays. This is a fire
  # test to make sure our fix for that does not regress
  shared_examples_for "a definition reset" do
    it "resets the definition while accounting for equality" do
      expect do
        expect_calling_with(ordering).to succeed
      end.to keep_the_same { ordering.reload.definition }.and change { ordering.reload.definition.as_json }
    end
  end

  context "with an inherited ordering" do
    context "that has been modified" do
      before do
        set_ordering_paths! ordering, "entity.title"
      end

      include_examples "a definition reset"

      it "restores the ordering to pristine status" do
        expect do
          expect_calling_with(ordering).to succeed
        end.to change(ordering, :pristine?).from(false).to(true)
      end

      it "updates the extracted paths" do
        expect do
          expect_calling_with(ordering).to succeed
        end.to change(ordering, :paths).from(%w[entity.title])
      end
    end
  end

  context "with a custom ordering" do
    let!(:ordering) do
      FactoryBot.create :ordering, :by_descending_title, entity: collection
    end

    include_examples "a definition reset"

    it "will reset the definition to a default" do
      expect do
        expect_calling_with(ordering).to succeed
      end.to change { ordering.reload.paths }.from(%w[entity.title]).to(%w[entity.updated_at])
    end

    it "has no effect on pristine status" do
      expect do
        expect_calling_with(ordering).to succeed
      end.to keep_the_same { ordering.reload.pristine? }
    end
  end
end
