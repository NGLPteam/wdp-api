class UpdateEntityDescendantsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    change_table :entity_hierarchies do |t|
      t.text :title

      t.index %i[title ancestor_type ancestor_id], name: "index_entity_hierarchies_by_descendant_title_asc"
      t.index %i[title ancestor_type ancestor_id], name: "index_entity_hierarchies_by_descendant_title_desc", order: { title: :desc }
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating hierarchy titles" do
          execute(<<~SQL.strip_heredoc).cmdtuples
          UPDATE entity_hierarchies hier SET title = ent.title
          FROM entities AS ent
          WHERE ent.entity_type = hier.hierarchical_type AND ent.entity_id = hier.hierarchical_id
          SQL
        end
      end
    end

    change_column_null :entity_hierarchies, :title, false

    update_view :entity_descendants, version: 2, revert_to_version: 1
  end
end
