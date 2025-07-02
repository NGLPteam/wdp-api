# frozen_string_literal: true

# Auxiliary introspection methods that are included in {EntityTemplating}
# but do not require re-running the generator.
module EntityTemplatingSupport
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    has_many :entity_derived_layout_definitions, as: :entity, inverse_of: :entity, dependent: :delete_all

    has_many_readonly :missing_layout_instances, as: :entity, inverse_of: :entity, class_name: "EntityMissingLayoutInstance"

    has_many_readonly :missing_template_instances, as: :entity, inverse_of: :entity, class_name: "EntityMissingTemplateInstance"

    scope :with_layout_invalidations, -> { where(id: LayoutInvalidation.distinct.select(:entity_id)) }
    scope :with_missing_layouts, -> { where(id: EntityMissingLayoutInstance.distinct.select(:entity_id)) }
    scope :with_missing_templates, -> { where(id: EntityMissingTemplateInstance.distinct.select(:entity_id)) }

    scope :with_derived_layout_definitions, -> { where.associated(:entity_derived_layout_definitions) }
    scope :sans_derived_layout_definitions, -> { where.missing(:entity_derived_layout_definitions) }

    scope :stale, -> { where(arel_build_staleness_condition) }
  end

  # @return [Dry::Monads::Success(Entities::LayoutsProxy)]
  # @return [Dry::Monads::Failure(:entity_deleted)]
  monadic_matcher! def check_layouts
    call_operation("entities.check_layouts", self)
  end

  # @see Entities::DeriveLayoutDefinitions
  # @see Entities::LayoutDefinitionsDeriver
  # @return [Dry::Monads::Success(Integer)]
  monadic_operation! def derive_layout_definitions
    call_operation("entities.derive_layout_definitions", entity: self)
  end

  def has_layout_invalidations?
    layout_invalidations.exists?
  end

  def has_missing_layouts?
    missing_layout_instances.exists?
  end

  def has_missing_templates?
    missing_template_instances.exists?
  end

  def has_no_layout_definitions_derived?
    !entity_derived_layout_definitions.exists?
  end

  # @return [String]
  def render_lock_key
    "render_lock/#{id}"
  end

  def stale?
    has_layout_invalidations? || has_missing_layouts? || has_missing_templates? || has_no_layout_definitions_derived?
  end

  # @return [HierarchicalEntity]
  def validated_layout_source
    if has_invalid_layouts?
      invalidation = layout_invalidations.latest

      invalidation.process!

      reload
    elsif has_missing_layouts?
      render_layouts!

      reload
    end

    return self
  end

  module ClassMethods
    # @api private
    def arel_build_staleness_condition
      sdl = arel_attr_in_query(:id, unscoped.sans_derived_layout_definitions.distinct.select(:id))
      wli = arel_attr_in_query(:id, unscoped.with_layout_invalidations.select(:id))
      wml = arel_attr_in_query(:id, unscoped.with_missing_layouts.select(:id))
      wmt = arel_attr_in_query(:id, unscoped.with_missing_templates.select(:id))

      arel_grouping(wli.or(sdl).or(wml).or(wmt))
    end
  end
end
