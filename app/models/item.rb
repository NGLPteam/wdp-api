# frozen_string_literal: true

class Item < ApplicationRecord
  include Accessible
  include Attachable
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity

  has_closure_tree

  belongs_to :collection, inverse_of: :items

  has_many :contributions, class_name: "ItemContribution", dependent: :destroy, inverse_of: :item
  has_many :contributors, through: :contributions

  has_many :item_links, foreign_key: :source_id, dependent: :destroy, inverse_of: :source
  has_many :targeting_item_links, class_name: "ItemLink", foreign_key: :target_id, dependent: :destroy, inverse_of: :target

  has_one :community, through: :collection

  validates :identifier, :title, presence: true
  validates :identifier, uniqueness: { scope: %i[collection_id parent_id] }

  # @return [Collection]
  def hierarchical_parent
    collection
  end
end
