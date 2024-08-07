# frozen_string_literal: true

module Settings
  # Settings related to how entities behave.
  #
  # @see GlobalConfiguration
  class Entities
    include Shared::EnhancedStoreModel

    attribute :suppress_external_links, :boolean, default: false

    def reset!
      self.suppress_external_links = false
    end
  end
end
