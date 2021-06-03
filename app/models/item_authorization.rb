# frozen_string_literal: true

class ItemAuthorization < ApplicationRecord
  include MaterializedView

  self.primary_key = :item_id

  belongs_to :collection
  belongs_to :community
  belongs_to :item
end
