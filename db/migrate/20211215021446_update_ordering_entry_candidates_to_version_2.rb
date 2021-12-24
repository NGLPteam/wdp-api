class UpdateOrderingEntryCandidatesToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :ordering_entry_candidates, version: 2, revert_to_version: 1
  end
end
