class CreateContributors < ActiveRecord::Migration[6.1]
  def change
    create_enum "contributor_kind", %w[person organization]

    create_table :contributors, id: :uuid do |t|
      t.enum :kind, enum_type: "contributor_kind", null: false

      t.citext :identifier, null: false

      t.citext :email
      t.text :prefix
      t.text :suffix
      t.text :bio
      t.text :url

      t.jsonb :image_data
      t.jsonb :properties
      t.jsonb :links

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
