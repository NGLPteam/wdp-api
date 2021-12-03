# frozen_string_literal: true

module Settings
  class Institution
    include StoreModel::Model

    attribute :name, :string, default: "Institution Name"

    validates :name, presence: true
  end
end
