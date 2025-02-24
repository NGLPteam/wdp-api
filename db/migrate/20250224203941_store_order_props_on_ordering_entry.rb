# frozen_string_literal: true

class StoreOrderPropsOnOrderingEntry < ActiveRecord::Migration[7.0]
  def change
    change_table :ordering_entries do |t|
      t.jsonb :order_props, null: false, default: {}
    end
  end
end
