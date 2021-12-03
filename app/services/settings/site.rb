# frozen_string_literal: true

module Settings
  class Site
    include StoreModel::Model
    include ActiveModel::Validations::Callbacks

    strip_attributes collapse_spaces: true

    attribute :provider_name, :string, default: "Service Provider Name"

    validates :provider_name, presence: true
  end
end
