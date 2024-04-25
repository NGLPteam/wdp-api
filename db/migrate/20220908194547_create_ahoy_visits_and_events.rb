class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :ahoy_visits, id: :uuid do |t|
      t.string :visit_token
      t.string :visitor_token

      # the rest are recommended but optional
      # simply remove any you don't want

      # user
      t.references :user, type: :uuid, foreign_key: { on_delete: :nullify }

      # standard
      t.inet :ip
      t.text :user_agent
      t.text :referrer
      t.text :referring_domain
      t.text :landing_page

      # technology
      t.text :browser
      t.text :os
      t.text :device_type

      # location
      t.text :country
      t.text :region
      t.text :city
      t.float :latitude
      t.float :longitude

      # utm parameters
      t.text :utm_source
      t.text :utm_medium
      t.text :utm_term
      t.text :utm_content
      t.text :utm_campaign

      # native apps
      t.text :app_version
      t.text :os_version
      t.text :platform

      t.datetime :started_at
    end

    add_index :ahoy_visits, :visit_token, unique: true

    create_enum "analytics_context", %w[admin frontend]

    create_table :ahoy_events, id: :uuid do |t|
      t.references :visit, type: :uuid, foreign_key: { on_delete: :cascade, to_table: :ahoy_visits }
      t.references :user, type: :uuid, foreign_key: { on_delete: :nullify }
      t.references :entity, type: :uuid, polymorphic: true
      t.references :subject, type: :uuid, polymorphic: true

      t.enum :context, enum_type: "analytics_context", null: false, default: "frontend"

      t.citext :name
      t.jsonb :properties
      t.datetime :time
    end

    add_index :ahoy_events, [:name, :time]
    add_index :ahoy_events, :properties, using: :gin, opclass: :jsonb_path_ops
  end
end
