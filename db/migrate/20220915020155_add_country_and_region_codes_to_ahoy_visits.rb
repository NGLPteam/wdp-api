class AddCountryAndRegionCodesToAhoyVisits < ActiveRecord::Migration[6.1]
  def change
    change_table :ahoy_visits do |t|
      t.text :country_code, null: true
      t.text :region_code, null: true
      t.text :postal_code, null: true
      t.timestamp :geocoded_at, null: true

      t.index %i[country_code region_code id], name: "index_visits_by_country_and_region_codes"
    end
  end
end
