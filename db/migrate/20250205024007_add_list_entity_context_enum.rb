# frozen_string_literal: true

class AddListEntityContextEnum < ActiveRecord::Migration[7.0]
  def change
    safe_create_enum :list_entity_context, %w[full abbr none]
  end

  private

  def safe_create_enum(name, ...)
    reversible do |dir|
      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP TYPE IF EXISTS #{name};
        SQL
      end
    end

    create_enum(name, ...)
  end
end
