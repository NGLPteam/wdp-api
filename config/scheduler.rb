# frozen_string_literal: true

# This file is used by the puma-rufus-scheduler plugin and otherwise ignored.

scheduler = Rufus::Scheduler.new

scheduler.every "1w" do
  Local::UpdateWebMaxmindJob.perform_async
rescue StandardError => e
  warn e
end

# This will attach scheduler thread to Puma's background thread.
scheduler.join
