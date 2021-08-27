# frozen_string_literal: true

module Contributors
  class Properties
    include StoreModel::Model

    attribute :organization, Contributors::OrganizationProperties.to_type
    attribute :person, Contributors::PersonProperties.to_type

    delegate :organization?, :person?, to: :parent, allow_nil: true

    validates :organization, store_model: true, if: :organization?
    validates :person, store_model: true, if: :person?
  end
end
