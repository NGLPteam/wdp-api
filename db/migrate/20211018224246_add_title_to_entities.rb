class AddTitleToEntities < ActiveRecord::Migration[6.1]
  def change
    change_table :entities do |t|
      t.citext :title, null: false, default: ""

      t.index :title
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating community titles" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET title = comm.title
          FROM communities AS comm
          WHERE comm.id = entities.entity_id AND entities.entity_type = 'Community'
          SQL
        end

        say_with_time "Populating collection titles" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET title = coll.title
          FROM collections AS coll
          WHERE coll.id = entities.entity_id AND entities.entity_type = 'Collection'
          SQL
        end

        say_with_time "Populating item titles" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET title = it.title
          FROM items AS it
          WHERE it.id = entities.entity_id AND entities.entity_type = 'Item'
          SQL
        end
      end
    end
  end
end
