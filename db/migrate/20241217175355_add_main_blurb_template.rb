# frozen_string_literal: true

class AddMainBlurbTemplate < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TYPE template_kind ADD VALUE IF NOT EXISTS 'blurb';
        ALTER TYPE main_template_kind ADD VALUE IF NOT EXISTS 'blurb';
        SQL
      end
    end

    create_enum :blurb_background, %w[none light dark]
  end
end
