# frozen_string_literal: true

module Contributors
  class OrganizationProperties
    include StoreModel::Model

    attribute :legal_name, :string
    attribute :location, :string

    validates :legal_name, presence: true

    def display_name
      legal_name
    end
  end
end
