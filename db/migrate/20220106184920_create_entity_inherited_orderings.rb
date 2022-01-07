class CreateEntityInheritedOrderings < ActiveRecord::Migration[6.1]
  def change
    create_view :entity_inherited_orderings
  end
end
