class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.date :published_on, null: false
      t.text :header, null: false
      t.text :teaser, null: false
      t.text :body, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_id entity_type published_on], order: { published_on: :desc }, name: "index_announcements_recent_by_entity"
      t.index %i[entity_id entity_type published_on], order: { published_on: :asc }, name: "index_announcements_oldest_by_entity"
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL)
        ALTER TABLE announcements ALTER COLUMN entity_type SET DATA TYPE text;
        SQL
      end
    end
  end
end
