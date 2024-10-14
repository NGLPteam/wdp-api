# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {HierarchicalEntity an entity}.
    #
    # @abstract
    # @see Templates::Drops::CommunityDrop
    # @see Templates::Drops::CollectionDrop
    # @see Templates::Drops::ItemDrop
    class AbstractEntityDrop < Templates::Drops::AbstractDrop
      # @param [HierarchicalEntity] entity
      def initialize(entity)
        super()

        @entity = entity
      end

      # @return [Templates::Drops::AncestorsDrop]
      memoize def ancestors
        Templates::Drops::AncestorsDrop.new(@entity)
      end

      # @return [Templates::Drops::PropsDrop]
      memoize def props
        Templates::Drops::PropsDrop.new(@entity)
      end

      # @return [Templates::Drops::ImageDrop]
      memoize def hero_image
        @entity.hero_image&.to_liquid
      end

      # @return [Templates::Drops::ImageDrop]
      memoize def thumbnail
        @entity.thumbnail&.to_liquid
      end

      class << self
        def entity_delegates!(*attributes)
          delegate *attributes, to: :@entity
        end
      end

      entity_delegates!(:title, :subtitle, :summary, :created_at, :updated_at)
    end
  end
end
