# frozen_string_literal: true

class AddContributorListFilter < ActiveRecord::Migration[7.0]
  def change
    create_enum "contributor_list_filter", %w[all authors]

    change_table :templates_contributor_list_definitions do |t|
      t.enum :filter, enum_type: :contributor_list_filter, null: false, default: "all"
    end
  end
end
