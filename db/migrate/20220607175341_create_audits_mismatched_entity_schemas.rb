class CreateAuditsMismatchedEntitySchemas < ActiveRecord::Migration[6.1]
  TABLES = %i[communities collections items].freeze

  def change
    TABLES.each do |table|
      change_table table do |t|
        t.index %i[id schema_version_id], unique: true, name: "index_#{table}_versioned_ids"
      end
    end

    create_view :audits_mismatched_entity_schemas
  end
end
