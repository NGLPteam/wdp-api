# frozen_string_literal: true

module Contributors
  class Link
    include StoreModel::Model

    attribute :url, :string
    attribute :title, :string

    validates :title, presence: true
    validates :url, presence: true, url: true
  end
end
