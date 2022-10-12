# frozen_string_literal: true

class PopulatePositionsForExistingCommunities < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        say_with_time "Populating position for existing communities" do
          exec_update <<~SQL
          WITH ranked AS (
            SELECT id AS community_id, title, dense_rank() OVER w AS new_position
            FROM communities
            WINDOW w AS (ORDER BY position ASC NULLS LAST, title ASC, created_at ASC)
          )
          UPDATE communities c SET position = r.new_position
          FROM ranked AS r WHERE r.community_id = c.id;
          SQL
        end
      end
    end
  end
end
