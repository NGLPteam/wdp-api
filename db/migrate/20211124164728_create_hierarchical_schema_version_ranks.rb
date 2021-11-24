class CreateHierarchicalSchemaVersionRanks < ActiveRecord::Migration[6.1]
  def change
    create_view :hierarchical_schema_version_ranks
  end
end
