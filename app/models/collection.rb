# frozen_string_literal: true

class Collection < ApplicationRecord
  include Accessible
  include Attachable
  include AutoIdentifier
  include Contributable
  include HarvestTarget
  include HasEntityVisibility
  include HasSchemaDefinition
  include HasSystemSlug
  include HasUniqueDOI
  include HierarchicalEntity
  include ChildEntity
  include ScopesForIdentifier

  has_closure_tree

  belongs_to :community, inverse_of: :collections

  has_many :contributions, class_name: "CollectionContribution", dependent: :destroy, inverse_of: :collection

  has_many :contributors, through: :contributions

  has_many :items, dependent: :destroy, inverse_of: :collection

  has_many_readonly :related_collection_links, foreign_key: :source_id, inverse_of: :source
  has_many_readonly :incoming_collection_links, foreign_key: :target_id, class_name: "RelatedCollectionLink", inverse_of: :target
  has_many_readonly :related_collections, through: :related_collection_links, source: :target

  validates :identifier, :title, presence: true
  validates :identifier, uniqueness: { scope: %i[community_id parent_id] }

  # @return [Community]
  def hierarchical_parent
    community
  end

  def hierarchical_children
    items
  end

  # @return [Collection, nil]
  def largest_child_collection
    children.preload(:entity_descendants).max_by { |c| c.entity_descendants.size }
  end
end
