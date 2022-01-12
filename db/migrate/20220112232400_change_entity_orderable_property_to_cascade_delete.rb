class ChangeEntityOrderablePropertyToCascadeDelete < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :entity_orderable_properties, :schema_version_properties, on_delete: :restrict

    add_foreign_key :entity_orderable_properties, :schema_version_properties, on_delete: :cascade
  end
end
