# frozen_string_literal: true

RSpec.describe Schemas::Utility::InstanceFor, type: :operation do
  context "with an entity link" do
    let!(:target) { FactoryBot.create :item }

    let!(:entity_link) { FactoryBot.create :entity_link, target: target }

    it "returns the link's target" do
      expect_calling_with(entity_link).to eq target
    end

    context "when passed its entity" do
      it "returns the target" do
        expect_calling_with(entity_link.entity).to eq target
      end
    end
  end

  context "with a collection" do
    let!(:collection) { FactoryBot.create :collection }

    it "returns itself" do
      expect_calling_with(collection).to eq collection
    end

    context "when passed its entity" do
      it "returns the actual instance" do
        expect_calling_with(collection.entity).to eq collection
      end
    end
  end

  context "with an item" do
    let!(:item) { FactoryBot.create :item }

    it "returns itself" do
      expect_calling_with(item).to eq item
    end

    context "when passed its entity" do
      it "returns the actual instance" do
        expect_calling_with(item.entity).to eq item
      end
    end
  end

  context "with anything else" do
    it "fails" do
      expect do
        operation.call FactoryBot.create :user
      end.to raise_error TypeError
    end
  end
end
