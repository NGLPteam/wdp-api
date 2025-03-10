# frozen_string_literal: true

class Item < ApplicationRecord
  include Accessible
  include Attachable
  include AutoIdentifier
  include Contributable
  include HasEntityVisibility
  include HasHarvestModificationStatus
  include HasSchemaDefinition
  include HasSystemSlug
  include HierarchicalEntity
  include ChildEntity
  include ScopesForIdentifier

  drop_klass Templates::Drops::ItemDrop

  has_closure_tree

  belongs_to :collection, inverse_of: :items

  has_many :attributions, -> { in_default_order }, class_name: "ItemAttribution", dependent: :delete_all, inverse_of: :item
  has_many :contributions, class_name: "ItemContribution", dependent: :destroy, inverse_of: :item
  has_many :contributors, through: :contributions

  has_one :community, through: :collection

  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :related_item_links, foreign_key: :source_id, inverse_of: :source
  has_many :incoming_item_links, foreign_key: :target_id, class_name: "RelatedItemLink", inverse_of: :target
  has_many :related_items, through: :related_item_links, source: :target
  # rubocop:enable Rails/HasManyOrHasOneDependent

  validates :identifier, :title, presence: true
  validates :identifier, uniqueness: { scope: %i[collection_id parent_id] }

  # @return [:item]
  def entity_kind
    :item
  end

  # @return [Collection]
  def hierarchical_parent
    collection
  end
end
