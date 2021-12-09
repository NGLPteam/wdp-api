class AddHeroImageToEntities < ActiveRecord::Migration[6.1]
  def change
    %i[communities collections items].each do |table|
      change_table table do |t|
        t.jsonb :hero_image_data
      end
    end
  end
end
