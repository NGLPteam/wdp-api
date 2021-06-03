class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_enum "asset_kind", %w[unknown image video audio pdf document archive]

    create_table :assets, id: :uuid do |t|
      t.references :attachable, null: false, polymorphic: true, type: :uuid
      t.references :parent, null: true, type: :uuid, foreign_key: { to_table: :assets, on_delete: :restrict }

      t.enum :kind, as: "asset_kind", null: false, default: "unknown"

      t.integer :position

      t.citext :name
      t.citext :content_type
      t.bigint :file_size

      t.text :alt_text
      t.text :caption

      t.jsonb :attachment_data

      t.jsonb :alternatives_data

      t.jsonb :preview_data

      t.jsonb :properties

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.references :community, null: true, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :collection, null: true, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :item, null: true, foreign_key: { on_delete: :restrict }, type: :uuid

      t.index :attachment_data, using: :gin
      t.index :preview_data, using: :gin
      t.index :file_size
      t.index :kind
      t.index :name

      t.index %i[attachable_id attachable_type position]
      t.index %i[parent_id position]
    end

    create_table :asset_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :asset_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "asset_anc_desc_idx"

    add_index :asset_hierarchies, [:descendant_id],
      name: "asset_desc_idx"
  end
end
