class AddIdentifierToCommunities < ActiveRecord::Migration[6.1]
  def change
    change_table :communities do |t|
      t.citext :identifier, null: true

      t.index :identifier, unique: true
    end

    reversible do |dir|
      dir.up do
        say_with_time "Updating existing communities with identifiers" do
          execute(<<~SQL).cmdtuples
          UPDATE communities SET identifier = system_slug;
          SQL
        end
      end
    end

    change_column_null :communities, :identifier, false
  end
end
