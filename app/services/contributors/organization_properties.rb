# frozen_string_literal: true

module Contributors
  class OrganizationProperties
    include StoreModel::Model

    attribute :legal_name, :string
    attribute :location, :string
  end
end
