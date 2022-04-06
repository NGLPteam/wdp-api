# frozen_string_literal: true

module Settings
  class Institution
    include Shared::EnhancedStoreModel

    strip_attributes collapse_spaces: true

    attribute :name, :string, default: ""

    validates :name, enforced_string: true

    # @api private
    # @return [void]
    def reset!
      self.name = ""
    end
  end
end
