# frozen_string_literal: true

module ImageAttachments
  module ToLiquid
    extend ActiveSupport::Concern

    # @return [Templates::Drops::ImageDrop]
    def to_liquid
      ::Templates::Drops::ImageDrop.new(self)
    end
  end
end
