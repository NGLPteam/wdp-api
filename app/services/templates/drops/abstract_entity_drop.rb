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
      # @return [Templates::Drops::VariablePrecisionDateDrop]
      attr_reader :published

      # @return [Templates::Drops::SchemaVersionDrop]
      attr_reader :schema

      # @param [HierarchicalEntity] entity
      def initialize(entity)
        super()

        @entity = entity
        @schema = entity.schema_version.to_liquid

        @published = Templates::Drops::VariablePrecisionDateDrop.new(entity.try(:published))
      end

      # @return [Templates::Drops::AuthorsDrop]
      memoize def authors
        Templates::Drops::AuthorsDrop.new(@entity)
      end

      # @return [Templates::Drops::ContributionsDrop]
      memoize def contributions
        Templates::Drops::ContributionsDrop.new(@entity)
      end

      # @return [Templates::Drops::OrderingsDrop]
      memoize def orderings
        Templates::Drops::OrderingsDrop.new(@entity)
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
      memoize def logo
        @entity.logo&.to_liquid
      end

      # @return [Templates::Drops::ImageDrop]
      memoize def thumbnail
        @entity.thumbnail&.to_liquid
      end

      def to_s
        # :nocov:
        call_operation!("templates.mdx.build_entity_link", entity: @entity, content: title)
        # :nocov:
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
