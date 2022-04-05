class CreateLatestHarvestAttemptLinks < ActiveRecord::Migration[6.1]
  def change
    create_view :latest_harvest_attempt_links
  end
end
