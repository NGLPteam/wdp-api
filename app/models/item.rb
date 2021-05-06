# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :collection, inverse_of: :items

  validates :title, :description, presence: true
end
