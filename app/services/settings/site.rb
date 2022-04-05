# frozen_string_literal: true

module Settings
  class Site
    include StoreModel::Model
    include ActiveModel::Validations::Callbacks

    strip_attributes collapse_spaces: true

    attribute :installation_name, :string, default: "Installation Name"
    attribute :provider_name, :string, default: "Service Provider Name"

    validates :installation_name, :provider_name, presence: true
  end
end
