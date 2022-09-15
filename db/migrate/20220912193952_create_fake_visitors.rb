class CreateFakeVisitors < ActiveRecord::Migration[6.1]
  def change
    create_table :fake_visitors, id: :uuid do |t|
      t.references :user, null: true, foreign_key: { on_delete: :cascade }, type: :uuid
      t.inet :ip, null: false
      t.citext :user_agent, null: false
      t.integer :sequence, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :sequence
    end
  end
end
