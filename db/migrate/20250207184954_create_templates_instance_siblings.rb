# frozen_string_literal: true

class CreateTemplatesInstanceSiblings < ActiveRecord::Migration[7.0]
  def change
    create_enum :sibling_kind, %w[prev next]

    create_view :templates_instance_siblings
  end
end
