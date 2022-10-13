class AddHerokuExtSchema < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE SCHEMA IF NOT EXISTS heroku_ext;
        SQL
      end
    end
  end
end
