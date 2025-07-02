# frozen_string_literal: true

RSpec.describe StaleEntity, type: :model do
  let_it_be(:entity) { FactoryBot.create :community }

  before do
    LayoutInvalidation.delete_all
  end

  it "is distinctly created by the presence of layout invalidation records" do
    expect do
      3.times do
        entity.invalidate_layouts!
      end
    end.to change(described_class, :count).by(1)
      .and change(LayoutInvalidation, :count).by(3)
  end
end
