# frozen_string_literal: true

RSpec.describe EntityVisibility, type: :model do
  specify "creating an entity creates its visibility" do
    expect do
      FactoryBot.create :collection
    end.to change(described_class, :count).by(1)
  end

  context "when accessing visibility from an Entity" do
    let!(:item) { FactoryBot.create :item }

    let!(:entity) { item.entity }

    it "is synchronized" do
      expect do
        item.visibility = :hidden

        item.save!
      end.to change { entity.reload.visibility_hidden? }.from(false).to(true)
    end
  end
end
