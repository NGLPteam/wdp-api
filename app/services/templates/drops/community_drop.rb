# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {Community a community}.
    #
    # @abstract
    class CommunityDrop < Templates::Drops::AbstractEntityDrop
      entity_delegates! :tagline

      # @return [Templates::Drops::ImageDrop]
      memoize def logo
        @entity.logo&.to_liquid
      end
    end
  end
end
