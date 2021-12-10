class AddNewPropertiesToEntities < ActiveRecord::Migration[6.1]
  def change
    %i[communities collections items].each do |table|
      change_table table do |t|
        t.text :subtitle
      end
    end

    %i[collections items].each do |table|
      change_table table do |t|
        t.text :issn

        t.index :issn
      end
    end

    change_table :entities do |t|
      t.jsonb :properties, default: {}, null: false

      t.index :properties, using: :gin, opclass: :jsonb_path_ops
    end

    reversible do |dir|
      dir.up do
        say_with_time "Inserting initial collection entity properties" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET properties = jsonb_build_object('doi', parent.doi)
          FROM collections AS parent WHERE parent.id = entities.entity_id AND entities.entity_type = 'Collection'
          SQL
        end

        say_with_time "Inserting initial item entity properties" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET properties = jsonb_build_object('doi', parent.doi)
          FROM items AS parent WHERE parent.id = entities.entity_id AND entities.entity_type = 'Item'
          SQL
        end
      end
    end
  end
end
