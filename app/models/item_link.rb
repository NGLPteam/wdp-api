# frozen_string_literal: true

class ItemLink < ApplicationRecord
  pg_enum! :operator, as: :item_link_operator, _prefix: :operator

  belongs_to :source, class_name: "Item", inverse_of: :item_links
  belongs_to :target, class_name: "Item", inverse_of: :targeting_item_links
end
