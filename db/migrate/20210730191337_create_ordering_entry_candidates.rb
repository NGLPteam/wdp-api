class CreateOrderingEntryCandidates < ActiveRecord::Migration[6.1]
  def change
    create_view :ordering_entry_candidates
  end
end
