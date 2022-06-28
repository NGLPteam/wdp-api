class CreateAuditsMismatchedCollectionParents < ActiveRecord::Migration[6.1]
  def change
    create_view :audits_mismatched_collection_parents
  end
end
