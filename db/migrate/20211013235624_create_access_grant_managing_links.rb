class CreateAccessGrantManagingLinks < ActiveRecord::Migration[6.1]
  def change
    create_view :access_grant_management_links
  end
end
