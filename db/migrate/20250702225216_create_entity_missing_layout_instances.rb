# frozen_string_literal: true

class CreateEntityMissingLayoutInstances < ActiveRecord::Migration[7.0]
  def change
    create_view :entity_missing_layout_instances
  end
end
