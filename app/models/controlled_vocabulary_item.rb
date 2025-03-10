# frozen_string_literal: true

# A term in a single {ControlledVocabulary}.
class ControlledVocabularyItem < ApplicationRecord
  include HasEphemeralSystemSlug
  include Liquifies
  include TimestampScopes

  drop_klass Templates::Drops::ControlledVocabularyItemDrop

  strip_attributes only: %i[identifier label description]

  belongs_to :controlled_vocabulary, inverse_of: :controlled_vocabulary_items

  has_many :collection_contributions, inverse_of: :role, foreign_key: :role_id, dependent: :restrict_with_error
  has_many :harvest_contributions, inverse_of: :role, foreign_key: :role_id, dependent: :restrict_with_error
  has_many :item_contributions, inverse_of: :role, foreign_key: :role_id, dependent: :restrict_with_error

  has_many :default_item_configurations, class_name: "ContributionRoleConfiguration", inverse_of: :default_item, dependent: :restrict_with_error
  has_many :other_item_configurations, class_name: "ContributionRoleConfiguration", inverse_of: :other_item, dependent: :restrict_with_error

  has_closure_tree order: "ranking", numeric_order: true, dont_order_roots: true

  scope :in_default_order, -> { reorder(arel_table[:priority].desc.nulls_last).order(position: :asc, identifier: :asc) }

  scope :tagged_with, ->(tag) { where(arel_value_in_array(tag, arel_table[:tags])) }

  validates :identifier, presence: true, uniqueness: { scope: :controlled_vocabulary_id }
  validates :label, presence: true

  after_commit :rerank_parent!, unless: :skip_rerank?

  # @return [void]
  def rerank_parent!
    controlled_vocabulary.rerank_items
  end

  # @return [Boolean]
  attr_accessor :skip_rerank

  alias skip_rerank? skip_rerank

  # @return [Hash]
  def to_item_set
    children = self.children.map(&:to_item_set).presence

    slice(:identifier, :label, :position, :description, :url).compact_blank.merge(
      id: to_encoded_id,
      children:,
      unselectable:,
    ).compact
  end

  class << self
    def first_tagged_with(tag)
      tagged_with(tag).in_default_order.first
    end
  end
end
