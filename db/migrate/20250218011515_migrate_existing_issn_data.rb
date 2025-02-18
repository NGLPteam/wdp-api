# frozen_string_literal: true

class MigrateExistingISSNData < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Copying collections.issn to property values" do
      exec_update(<<~SQL.strip_heredoc.strip)
      UPDATE collections SET properties = jsonb_set(properties, ARRAY['values', 'issn'], to_jsonb(issn))
      WHERE issn IS NOT NULL AND issn <> '' AND properties #>> ARRAY['values', 'issn'] IS NULL;
      SQL
    end
  end

  def down
    # Intentionally left blank
  end
end
