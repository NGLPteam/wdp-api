# frozen_string_literal: true

module Types
  # @see EntityTemplating
  class EntityLayoutsType < Types::BaseObject
    description <<~TEXT
    An accessor for pulling up layout instances for a given entity.
    TEXT

    field :hero, ::Types::Layouts::HeroLayoutInstanceType, null: true do
      description <<~TEXT
      The `HERO` layout instance for this entity.
      TEXT
    end

    field :list_item, ::Types::Layouts::ListItemLayoutInstanceType, null: true do
      description <<~TEXT
      The `LIST_ITEM` layout instance for this entity.
      TEXT
    end

    field :main, ::Types::Layouts::MainLayoutInstanceType, null: true do
      description <<~TEXT
      The `MAIN` layout instance for this entity.
      TEXT
    end

    field :navigation, ::Types::Layouts::NavigationLayoutInstanceType, null: true do
      description <<~TEXT
      The `NAVIGATION` layout instance for this entity.
      TEXT
    end

    field :metadata, ::Types::Layouts::MetadataLayoutInstanceType, null: true do
      description <<~TEXT
      The `METADATA` layout instance for this entity.
      TEXT
    end

    field :supplementary, ::Types::Layouts::SupplementaryLayoutInstanceType, null: true do
      description <<~TEXT
      The `SUPPLEMENTARY` layout instance for this entity.
      TEXT
    end

    load_association! :hero_layout_instance, as: :hero

    load_association! :list_item_layout_instance, as: :list_item

    load_association! :main_layout_instance, as: :main

    load_association! :navigation_layout_instance, as: :navigation

    load_association! :metadata_layout_instance, as: :metadata

    load_association! :supplementary_layout_instance, as: :supplementary
  end
end
