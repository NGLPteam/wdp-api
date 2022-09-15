class CreateRollups < ActiveRecord::Migration[6.1]
  def change
    create_table :rollups, id: :uuid do |t|
      t.citext :name, null: false
      t.citext :interval, null: false
      t.datetime :time, null: false
      t.jsonb :dimensions, null: false, default: {}
      t.decimal :value, precision: 21, scale: 4
    end

    add_index :rollups, [:name, :interval, :time, :dimensions], unique: true
  end
end
