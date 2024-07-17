class CreateControlledVocabularySources < ActiveRecord::Migration[7.0]
  def change
    create_table :controlled_vocabulary_sources, id: :uuid do |t|
      t.references :controlled_vocabulary, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.text :provides, null: false

      t.timestamps

      t.index :provides, unique: true
    end
  end
end
