# frozen_string_literal: true

class CollectionLink < ApplicationRecord
  pg_enum! :operator, as: :collection_link_operator, _prefix: :operator

  belongs_to :source, class_name: "Collection", inverse_of: :collection_links
  belongs_to :target, class_name: "Collection", inverse_of: :targeting_collection_links
end
