# frozen_string_literal: true

class Collection < ApplicationRecord
  include Accessible
  include Attachable
  include AutoIdentifier
  include Contributable
  include HasEntityVisibility
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity
  include ScopesForIdentifier

  has_closure_tree

  belongs_to :community, inverse_of: :collections

  has_many :contributions, class_name: "CollectionContribution", dependent: :destroy, inverse_of: :collection

  has_many :contributors, through: :contributions

  has_many :items, dependent: :destroy, inverse_of: :collection

  has_many :harvest_attempts, inverse_of: :collection, dependent: :destroy
  has_many :harvest_mappings, inverse_of: :collection, dependent: :destroy

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
