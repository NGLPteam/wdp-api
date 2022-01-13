class AddCommunityProperties < ActiveRecord::Migration[6.1]
  def change
    change_table :communities do |t|
      t.text :hero_image_layout, null: false, default: "one_column"
      t.jsonb :logo_data
      t.text :summary
      t.text :tagline
    end
  end
end
