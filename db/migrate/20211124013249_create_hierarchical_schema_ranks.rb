class CreateHierarchicalSchemaRanks < ActiveRecord::Migration[6.1]
  def change
    create_view :hierarchical_schema_ranks
  end
end
