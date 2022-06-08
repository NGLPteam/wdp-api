class UpdateHierarchicalSchemaRanksToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :hierarchical_schema_ranks, version: 2, revert_to_version: 1
  end
end
