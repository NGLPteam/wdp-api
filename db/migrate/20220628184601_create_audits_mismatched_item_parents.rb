class CreateAuditsMismatchedItemParents < ActiveRecord::Migration[6.1]
  def change
    create_view :audits_mismatched_item_parents
  end
end
