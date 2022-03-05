class CreateHarvestErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_errors, id: :uuid do |t|
      t.references :source, polymorphic: true, null: false, type: :uuid
      t.text :code
      t.text :message
      t.jsonb :metadata, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
