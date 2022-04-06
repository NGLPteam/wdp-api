# frozen_string_literal: true

module Settings
  class Site
    include Shared::EnhancedStoreModel

    strip_attributes collapse_spaces: true

    attribute :installation_name, :string, default: ""
    attribute :provider_name, :string, default: ""
    attribute :footer, Settings::SiteFooter.to_type, default: {}

    validates :installation_name, :provider_name, enforced_string: true
    validates :footer, store_model: true

    # @return [void]
    def reset!
      self.installation_name = ""
      self.provider_name = ""
      footer.reset!
    end
  end
end
