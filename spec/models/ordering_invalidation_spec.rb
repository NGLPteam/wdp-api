# frozen_string_literal: true

RSpec.describe OrderingInvalidation, type: :model do
  describe ".stale" do
    let_it_be(:ordering, refind: true) { FactoryBot.create :ordering }

    it "uses DISTINCT ON to limit to one record per ordering" do
      # sanity check
      expect do
        ordering.invalidate(stale_at: 10.minutes.ago)
        ordering.invalidate(stale_at: 5.minutes.ago)
      end.to change(described_class, :count).by(2)

      expect(described_class.where(ordering:).stale.count).to eq 1
    end
  end
end
