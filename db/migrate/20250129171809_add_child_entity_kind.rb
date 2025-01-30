# frozen_string_literal: true

class AddChildEntityKind < ActiveRecord::Migration[7.0]
  def change
    create_enum :child_entity_kind, %w[collection item]
  end
end
