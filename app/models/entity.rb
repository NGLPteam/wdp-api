# frozen_string_literal: true

# This is a composite table, with records created by a {HierarchicalEntity},
# that allows all models implementing that interface to be combined into a
# single table for use with other parts of the application.
#
# In future, it will also be used to insert linked entries into the hierarchy.
class Entity < ApplicationRecord
  include FiltersByEntityScope
  include FiltersBySchemaVersion
  include ScopesForHierarchical
  include ReferencesEntityVisibility
  include ReferencesNamedVariableDates
  include EntityReferent
  include ScopesForAuthPath
  include ScopesForEntityComposedText
  include TimestampScopes

  belongs_to :entity, polymorphic: true
  belongs_to :hierarchical, polymorphic: true
  belongs_to :schema_version

  has_one :schema_definition, through: :schema_version

  CONTEXTUAL_TUPLE = %i[hierarchical_type hierarchical_id].freeze

  ENTITY_TUPLE = %i[entity_type entity_id].freeze

  has_many_readonly :contextual_permissions, primary_key: CONTEXTUAL_TUPLE, foreign_key: CONTEXTUAL_TUPLE

  has_many_readonly :entity_breadcrumbs, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

  has_one_readonly :entity_composed_text, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :entity_inherited_orderings, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

  has_one_readonly :entity_visibility, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :named_variable_dates, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :layout_invalidations, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  scope :with_schema_name_asc, -> { joins(:schema_definition).merge(SchemaDefinition.order(name: :asc)) }
  scope :with_schema_name_desc, -> { joins(:schema_definition).merge(SchemaDefinition.order(name: :desc)) }

  scope :with_missing_orderings, -> { non_link.where(entity_id: EntityInheritedOrdering.missing.select(:entity_id)) }
  scope :except_hierarchical, ->(hierarchical) { where.not(hierarchical:) if hierarchical.present? }
  scope :filtered_by_ancestor_schema, ->(schemas) { where(hierarchical_id: EntityBreadcrumb.filtered_by_schema_version(schemas).select(:entity_id)) }

  scope :actual, -> { where(scope: %w[communities items collections]) }
  scope :non_link, -> { where(link_operator: nil) }
  scope :real, -> { preload(:entity).non_link }
  scope :sans_thumbnail, -> { real.where(arel_sans_thumbnail) }
  scope :unharvested, -> { where.not(hierarchical_id: HarvestEntity.existing_entity_ids) }

  scope :sans_analytics, -> { where.not(hierarchical_id: Ahoy::Event.distinct.select(:entity_id)) }

  # @see Entities::InvalidateLayouts
  # @return [Dry::Monads::Success(void)]
  monadic_operation! def invalidate_layouts
    call_operation("entities.invalidate_layouts", self)
  end

  def schema_kind
    hierarchical_type&.underscore
  end

  # We want to send the ID for the actual {HierarchicalEntity} this maps to.
  def to_schematic_referent_value
    hierarchical.to_encoded_id
  end

  class << self
    # @see Resolvers::SearchResultsResolver
    # @param [String] text
    # @return [ActiveRecord::Relation<Entity>]
    def apply_query(text)
      compiler = Searching::QueryCompiler.new text, scope: all

      compiler.()
    end

    # @see Resolvers::SearchResultsResolver
    # @param [String] text
    # @return [ActiveRecord::Relation<Entity>]
    def apply_prefix(text)
      compiler = Searching::PrefixCompiler.new text, scope: all

      compiler.()
    end

    # @api private
    # @see Resolvers::SearchResultsResolver
    # @param [<Searching::Operator>] predicates
    # @return [ActiveRecord::Relation<Entity>]
    def apply_search_predicates(predicates)
      return all if predicates.blank?

      compiler = Searching::PredicateCompiler.new predicates, scope: all

      compiled = compiler.()

      compiled.nil? ? all : where(id: compiled)
    end

    # @api private
    # @return [ActiveRecord::Relation]
    def apply_order_to_exclude_duplicate_links
      order(:hierarchical_id).
        distinct_on_order_values.
        order(arel_table[:link_operator].asc.nulls_first)
    end

    # @param [Integer] max_depth
    # @param [Integer] origin_depth
    # @return [ActiveRecord::Relation]
    def by_max_relative_depth(max_depth, origin_depth: 0)
      relative_depth = arel_table[:depth] - origin_depth

      matches = relative_depth.lteq(max_depth).and(arel_table[:depth].gt(origin_depth))

      where matches
    end

    # @param [#auth_path] parent
    # @return [ActiveRecord::Relation<Entity>]
    def descending_from(parent)
      return none unless parent.present? && parent.respond_to?(:auth_path) && parent.auth_path.present?

      where arel_auth_path_contained_by parent.auth_path
    end

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

    # @param [String] containing_auth_path
    # @return [Arel::Nodes::And(Arel::Nodes::Inequality, Arel::Nodes::InfixOperation("<@"))]
    def arel_auth_path_contained_by(containing_auth_path)
      auth_path = arel_table[:auth_path]

      not_same = auth_path.not_eq(containing_auth_path)

      contained = arel_infix("<@", auth_path, arel_quote(containing_auth_path))

      not_same.and(contained)
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
