# frozen_string_literal: true

class Collection < ApplicationRecord
  include Accessible
  include Attachable
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity

  has_closure_tree

  belongs_to :community, inverse_of: :collections

  has_many :collection_links, foreign_key: :source_id, dependent: :destroy, inverse_of: :source
  has_many :targeting_collection_links, class_name: "CollectionLink", foreign_key: :target_id, dependent: :destroy, inverse_of: :target
  has_many :linked_collections, through: :collection_links, source: :target

  has_many :collection_linked_items, foreign_key: :source_id, dependent: :destroy, inverse_of: :source
  has_many :linked_items, through: :collection_linked_items, source: :target

  has_many :contributions, class_name: "CollectionContribution", dependent: :destroy, inverse_of: :collection

  has_many :contributors, through: :contributions

  has_many :items, dependent: :destroy, inverse_of: :collection

  validates :identifier, :title, presence: true
  validates :identifier, uniqueness: { scope: %i[community_id parent_id] }

  # @return [Community]
  def hierarchical_parent
    community
  end

  def hierarchical_children
    items
  end
end
