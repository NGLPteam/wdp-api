# frozen_string_literal: true

# A join model connecting a sorted {HierarchicalEntity entity} with an {Ordering}.
class OrderingEntry < ApplicationRecord
  include EntityAdjacent

  self.primary_key = %i[ordering_id id]

  belongs_to :ordering, inverse_of: :ordering_entries

  has_many :ordering_entry_ancestor_links, -> { in_order },
    foreign_key: %i[ordering_id child_id], inverse_of: :child, dependent: :delete_all

  has_many_readonly :ordering_entry_descendant_links, class_name: "OrderingEntryAncestorLink",
    foreign_key: %i[ordering_id ancestor_id], inverse_of: :ancestor, dependent: :delete_all

  has_many :ancestors, through: :ordering_entry_ancestor_links

  has_one :ordering_entry_sibling_link, foreign_key: %i[ordering_id sibling_id], dependent: :delete, inverse_of: :sibling

  has_one :prev_sibling, through: :ordering_entry_sibling_link, source: :prev
  has_one :next_sibling, through: :ordering_entry_sibling_link, source: :next

  belongs_to :entity, polymorphic: true, inverse_of: :ordering_entries

  scope :to_preload, -> { includes(:entity, ancestors: %i[entity]) }

  scope :in_default_order, -> { reorder(position: :asc) }
  scope :in_inverse_order, -> { reorder(inverse_position: :asc) }

  scope :by_ordering, ->(ordering) { where(ordering:) }
  scope :by_entity, ->(entity) { where(entity:) }

  class << self
    # @param [Ordering] ordering
    # @return [Integer]
    def delete_stale_for(ordering)
      by_ordering(ordering).where.not(stale_at: nil).delete_all
    end

    # @param [HierarchicalEntity] entity
    # @return [ActiveRecord::Relation<OrderingEntry>]
    def linking_to(entity)
      where(entity_type: "EntityLink", entity_id: entity.incoming_links.select(:id))
    end

    # @param [<Ordering>] orderings
    # @return [{ String => Integer }]
    def visible_count_for(orderings)
      currently_visible.by_ordering(orderings).group(:ordering_id).count
    end
  end
end
