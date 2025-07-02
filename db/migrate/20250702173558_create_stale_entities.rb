# frozen_string_literal: true

class CreateStaleEntities < ActiveRecord::Migration[7.0]
  def change
    create_view :stale_entities
  end
end
