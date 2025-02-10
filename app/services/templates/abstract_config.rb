# frozen_string_literal: true

module Templates
  # @abstract
  class AbstractConfig
    include Support::EnhancedStoreModel

    attribute :background, :string
    attribute :dark, :boolean, default: false
    attribute :variant, :string

    # @param [Templates::AbstractConfig] other
    # @return [void]
    def accept!(other)
      assign_attributes(other.as_json)

      return
    end
  end
end
