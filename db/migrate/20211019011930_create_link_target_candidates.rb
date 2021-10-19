class CreateLinkTargetCandidates < ActiveRecord::Migration[6.1]
  def change
    create_view :link_target_candidates
  end
end
