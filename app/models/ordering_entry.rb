# frozen_string_literal: true

class OrderingEntry < ApplicationRecord
  self.primary_key = %i[ordering_id id]

  belongs_to :ordering, inverse_of: :ordering_entries

  belongs_to :entity, polymorphic: true, inverse_of: :ordering_entries

  scope :in_order, -> { order(position: :asc) }

  scope :by_ordering, ->(ordering) { where(ordering: ordering) }
  scope :by_entity, ->(entity) { where(entity: entity) }

  class << self
    # @param [HierarchicalEntity] entity
    # @return [ActiveRecord::Relation<OrderingEntry>]
    def linking_to(entity)
      where(entity_type: "EntityLink", entity_id: entity.incoming_links.select(:id))
    end

    # @param [Ordering] ordering
    # @param [<String>] ids
    # @return [void]
    def purge(ordering, ids)
      by_ordering(ordering).where.not(id: ids).delete_all
    end
  end
end
