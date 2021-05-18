# frozen_string_literal: true

class EnableExtensions < ActiveRecord::Migration[6.1]
  def change
    enable_extension "citext"
    enable_extension "intarray"
    enable_extension "ltree"
    enable_extension "pgcrypto"
    enable_extension "plpgsql"
  end
end
