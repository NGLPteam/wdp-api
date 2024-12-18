# frozen_string_literal: true

RSpec.describe OrderingInvalidations::ProcessAllJob, type: :job do
  let_it_be(:ordering, refind: true) { FactoryBot.create :ordering }

  it "clears the invalidations" do
    # sanity check
    expect do
      ordering.invalidate!(stale_at: 5.minutes.ago)
      ordering.invalidate!(stale_at: 1.minute.ago)
    end.to change(OrderingInvalidation, :count).by(2)

    expect do
      described_class.perform_now
    end.to change(OrderingInvalidation, :count).by(-2)
  end
end
