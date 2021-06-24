# frozen_string_literal: true

# This is a composite table, with records created by a {HierarchicalEntity},
# that allows all models implementing that interface to be combined into a
# single table for use with other parts of the application.
#
# In future, it will also be used to insert linked entries into the hierarchy.
class Entity < ApplicationRecord
  include ScopesForHierarchical

  belongs_to :entity, polymorphic: true
  belongs_to :hierarchical, polymorphic: true

  CONTEXTUAL_TUPLE = %i[hierarchical_type hierarchical_id].freeze

  # rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
  has_many :contextual_permissions, primary_key: CONTEXTUAL_TUPLE, foreign_key: CONTEXTUAL_TUPLE
  # rubocop:enable Rails/HasManyOrHasOneDependent, Rails/InverseOf

  scope :sans_thumbnail, -> { where(arel_sans_thumbnail) }

  class << self
    # @return [void]
    def resync!
      Entities::SynchronizeCommunitiesJob.perform_later
      Entities::SynchronizeCollectionsJob.perform_later
      Entities::SynchronizeItemsJob.perform_later
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
