class CreateSchematicCollectedReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :schematic_collected_references, id: :uuid do |t|
      t.references :referrer, polymorphic: true, null: false, type: :uuid
      t.references :referent, polymorphic: true, null: false, type: :uuid
      t.citext :path, null: false
      t.integer :position

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[referrer_type referrer_id referent_type referent_id path], unique: true, name: "index_schematic_collected_references_uniqueness"
      t.index %i[referrer_type referrer_id path position], name: "index_schematic_collected_references_ordering"
    end
  end
end
