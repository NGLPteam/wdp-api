class AlterEntityNulls < ActiveRecord::Migration[6.1]
  def change
    change_column_null :collections, :title, false
    change_column_null :collections, :summary, true

    change_column_null :items, :title, false
    change_column_null :items, :summary, true
  end
end
