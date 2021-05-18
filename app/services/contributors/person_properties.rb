# frozen_string_literal: true

module Contributors
  class PersonProperties
    include StoreModel::Model

    attribute :given_name, :string
    attribute :family_name, :string
    attribute :title, :string
    attribute :affiliation, :string
  end
end
