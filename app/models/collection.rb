# frozen_string_literal: true

class Collection < ApplicationRecord
  has_many :items, dependent: :destroy, inverse_of: :collection

  validates :title, :description, presence: true
end
