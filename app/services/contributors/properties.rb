# frozen_string_literal: true

module Contributors
  class Properties
    include StoreModel::Model

    attribute :organization, Contributors::OrganizationProperties.to_type
    attribute :person, Contributors::PersonProperties.to_type
  end
end
