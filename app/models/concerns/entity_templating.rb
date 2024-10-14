# frozen_string_literal: true

# @see ::Types::EntityLayoutsType
module EntityTemplating
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    has_many :layout_invalidations, as: :entity, inverse_of: :entity, dependent: :delete_all

    has_many :hero_layout_definitions,
      class_name: "Layouts::HeroDefinition",
      as: :entity,
      dependent: :destroy
    has_one :hero_layout_instance,
      class_name: "Layouts::HeroInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy
    has_many :list_item_layout_definitions,
      class_name: "Layouts::ListItemDefinition",
      as: :entity,
      dependent: :destroy
    has_one :list_item_layout_instance,
      class_name: "Layouts::ListItemInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy
    has_many :main_layout_definitions,
      class_name: "Layouts::MainDefinition",
      as: :entity,
      dependent: :destroy
    has_one :main_layout_instance,
      class_name: "Layouts::MainInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy
    has_many :navigation_layout_definitions,
      class_name: "Layouts::NavigationDefinition",
      as: :entity,
      dependent: :destroy
    has_one :navigation_layout_instance,
      class_name: "Layouts::NavigationInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy
    has_many :metadata_layout_definitions,
      class_name: "Layouts::MetadataDefinition",
      as: :entity,
      dependent: :destroy
    has_one :metadata_layout_instance,
      class_name: "Layouts::MetadataInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy
    has_many :supplementary_layout_definitions,
      class_name: "Layouts::SupplementaryDefinition",
      as: :entity,
      dependent: :destroy
    has_one :supplementary_layout_instance,
      class_name: "Layouts::SupplementaryInstance",
      as: :entity,
      inverse_of: :entity,
      dependent: :destroy

    after_save_commit :invalidate_layouts!
  end

  # @see Entities::InvalidateLayouts
  # @return [Dry::Monads::Success(void)]
  monadic_operation! def invalidate_layouts
    call_operation("entities.invalidate_layouts", self)
  end

  # @see Entities::RenderLayout
  # @see Entities::LayoutRenderer
  # @param [Layouts::Types::Kind] layout_kind
  # @return [Dry::Monads::Success(HierarchicalEntity)]
  monadic_matcher! def render_layout(layout_kind)
    call_operation("entities.render_layout", self, layout_kind:)
  end

  # @see Entities::RenderLayouts
  # @see Entities::LayoutsRenderer
  # @return [Dry::Monads::Success(HierarchicalEntity)]
  monadic_matcher! def render_layouts
    call_operation("entities.render_layouts", self)
  end
end
