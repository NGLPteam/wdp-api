# frozen_string_literal: true

class CreateEntityMissingTemplateInstances < ActiveRecord::Migration[7.0]
  def change
    create_view :entity_missing_template_instances
  end
end
