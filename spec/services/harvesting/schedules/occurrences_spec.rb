# frozen_string_literal: true

RSpec.describe Harvesting::Schedules::Occurrences do
  describe ".fetch" do
    it "handles an empty cron expression", :aggregate_failures do
      expect(described_class.fetch(nil)).to eq []
      expect(described_class.fetch("")).to eq []
      expect(described_class.fetch("  ")).to eq []
    end

    it "handles an invalid cron expression" do
      expect(described_class.fetch("something that will never parse guaranteed")).to eq []
    end

    it "handles a valid cron expression" do
      expect(described_class.fetch("every 4 hours")).to have(10).items
    end

    it "will skip occurrences that are happening too soon for the current time" do
      start_time = Time.current.at_beginning_of_hour
      after_time = start_time + 1.hour

      expect(described_class.fetch("every 30 minutes", occurrences_count: 4, start_time:)).to all(have_attributes(scheduled_at: be >= after_time))
    end
  end
end
