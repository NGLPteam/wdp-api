class CreateSchematicScalarReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :schematic_scalar_references, id: :uuid do |t|
      t.references :referrer, polymorphic: true, null: false, type: :uuid
      t.references :referent, polymorphic: true, null: false, type: :uuid
      t.citext :path, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[referrer_type referrer_id path], unique: true, name: "index_schematic_scalar_references_uniqueness"
    end
  end
end
