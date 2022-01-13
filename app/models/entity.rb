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

  belongs_to :entity, polymorphic: true
  belongs_to :hierarchical, polymorphic: true
  belongs_to :schema_version

  CONTEXTUAL_TUPLE = %i[hierarchical_type hierarchical_id].freeze

  ENTITY_TUPLE = %i[entity_type entity_id].freeze

  has_many_readonly :contextual_permissions, primary_key: CONTEXTUAL_TUPLE, foreign_key: CONTEXTUAL_TUPLE

  has_many_readonly :entity_inherited_orderings, primary_key: ENTITY_TUPLE, foreign_key: ENTITY_TUPLE

  has_one_readonly :entity_visibility, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  has_many_readonly :named_variable_dates, primary_key: CONTEXTUAL_TUPLE, foreign_key: ENTITY_TUPLE

  scope :with_missing_orderings, -> { non_link.where(entity_id: EntityInheritedOrdering.missing.select(:entity_id)) }

  scope :actual, -> { where(scope: %w[communities items collections]) }
  scope :non_link, -> { where(link_operator: nil) }
  scope :real, -> { preload(:entity).non_link }
  scope :sans_thumbnail, -> { real.where(arel_sans_thumbnail) }

  def schema_kind
    hierarchical_type&.underscore
  end

  class << self
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
