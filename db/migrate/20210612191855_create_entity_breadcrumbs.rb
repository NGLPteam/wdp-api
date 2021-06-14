class CreateEntityBreadcrumbs < ActiveRecord::Migration[6.1]
  def change
    create_view :entity_breadcrumbs
  end
end
