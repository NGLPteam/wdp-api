# frozen_string_literal: true

class AddEntitiesToGlobalConfigurations < ActiveRecord::Migration[7.0]
  def change
    change_table :global_configurations do |t|
      t.rename :schema, :entities
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting default entity configs" do
          exec_update(<<~SQL.strip_heredoc.strip)
          UPDATE global_configurations SET entities = jsonb_build_object('suppress_external_links', false);
          SQL
        end
      end
    end
  end
end
