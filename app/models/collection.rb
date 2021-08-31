# frozen_string_literal: true

class Collection < ApplicationRecord
  include Accessible
  include Attachable
  include Contributable
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity

  has_closure_tree

  belongs_to :community, inverse_of: :collections

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
