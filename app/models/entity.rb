# frozen_string_literal: true

# This is a composite table, with records created by a {HierarchicalEntity},
# that allows all models implementing that interface to be combined into a
# single table for use with other parts of the application.
#
# In future, it will also be used to insert linked entries into the hierarchy.
class Entity < ApplicationRecord
  include FiltersBySchemaVersion
  include ScopesForHierarchical
  include ReferencesEntityVisibility
  include ReferencesNamedVariableDates
  include EntityReferent
  include ScopesForAuthPath

  belongs_to :entity, polymorphic: true
  belongs_to :hierarchical, polymorphic: true
  belongs_to :schema_version

  CONTEXTUAL_TUPLE = %i[hierarchical_type hierarchical_id].freeze

  ENTITY_TUPLE = %i[entity_type entity_id].freeze

  has_many_readonly :contextual_permissions, primary_key: CONTEXTUAL_TUPLE, foreign_key: CONTEXTUAL_TUPLE

  has_many_readonly :entity_breadcrumbs, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :entity_inherited_orderings, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

  has_one_readonly :entity_visibility, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :named_variable_dates, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  scope :with_missing_orderings, -> { non_link.where(entity_id: EntityInheritedOrdering.missing.select(:entity_id)) }
  scope :except_hierarchical, ->(hierarchical) { where.not(hierarchical: hierarchical) if hierarchical.present? }
  scope :filtered_by_ancestor_schema, ->(schemas) { where(hierarchical_id: EntityBreadcrumb.filtered_by_schema_version(schemas).select(:entity_id)) }

  scope :actual, -> { where(scope: %w[communities items collections]) }
  scope :non_link, -> { where(link_operator: nil) }
  scope :real, -> { preload(:entity).non_link }
  scope :sans_thumbnail, -> { real.where(arel_sans_thumbnail) }

  def schema_kind
    hierarchical_type&.underscore
  end

  # We want to send the ID for the actual {HierarchicalEntity} this maps to.
  def to_schematic_referent_value
    hierarchical.to_encoded_id
  end

  class << self
    # @param [String] base
    # @param [String] ancestor
    def of_type_with_ancestor_of_type?(base, ancestor)
      filtered_by_schema_version(base).filtered_by_ancestor_schema(ancestor).exists?
    end

    def with_nested_type(base)
      filtered_by_schema_version(base).filtered_by_ancestor_schema(base)
    end

    def with_nested_type?(base)
      with_nested_type(base).exists?
    end

    # @param [User] user
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def readable_by(user)
      with_permitted_actions_for(user, "self.read")
    end

    # @param [User] user
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def with_permitted_actions_for(user, *actions)
      constraint = ContextualSinglePermission.with_permitted_actions_for(user, *actions).select(:hierarchical_type, :hierarchical_id)

      subquery = arel_quote_query constraint

      left = Arel::Nodes::GroupingElement.new([arel_table[:hierarchical_type], arel_table[:hierarchical_id]])

      expr = left.in(subquery)

      where(expr).where(link_operator: nil)
    end

    def sample_entities(count = nil)
      preload(:hierarchical).actual.scoped_sample(count).map(&:hierarchical)
    end

    # @see Schemas::Properties::References::Entities::Scopes::Links
    # @param [HierarchicalEntity] hierarchical
    # @param [:both, :outgoing, :incoming] direction
    # @return [ActiveRecord::Relation<EntityLink>]
    def links_for(hierarchical, direction: :both)
      subquery =
        case direction
        when /incoming/ then EntityLink.sources_for(hierarchical)
        when /outgoing/ then EntityLink.targets_for(hierarchical)
        else
          EntityLink.sources_and_targets_for(hierarchical)
        end

      left = Arel::Nodes::GroupingElement.new([arel_table[:hierarchical_type], arel_table[:hierarchical_id]])

      expr = left.in(subquery)

      where(expr).where(link_operator: nil)
    end

    # @return [void]
    def resync!
      Entities::SynchronizeAllJob.perform_later
    end

    # @api private
    def arel_sans_thumbnail
      Arel::Nodes::Case.new(arel_table[:entity_type]).tap do |stmt|
        [Community, Collection, Item].each do |model|
          expr = arel_attr_in_query(:entity_id, model.sans_thumbnail.select(:id))

          stmt.when(model.model_name.to_s).then(expr)
        end

        stmt.else(false)
      end
    end
  end
end
