# frozen_string_literal: true

module Contributors
  class OrganizationProperties
    include StoreModel::Model
    include Digestable

    attribute :legal_name, :string
    attribute :location, :string

    validates :legal_name, presence: true

    def digestable?
      legal_name.present?
    end

    def digest
      digest_with do |dig|
        dig << "legal_name" << legal_name
      end
    end

    def display_name
      legal_name
    end
  end
end
