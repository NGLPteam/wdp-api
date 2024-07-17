# frozen_string_literal: true

# A term in a single {ControlledVocabulary}.
class ControlledVocabularyItem < ApplicationRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  strip_attributes only: %i[identifier label description]

  belongs_to :controlled_vocabulary, inverse_of: :controlled_vocabulary_items

  has_closure_tree order: "position", numeric_order: true, dont_order_roots: true

  scope :in_default_order, -> { order(position: :asc) }

  validates :identifier, presence: true, uniqueness: { scope: :controlled_vocabulary_id }
  validates :label, presence: true

  # @return [Hash]
  def to_item_set
    children = self.children.map(&:to_item_set).presence

    slice(:identifier, :label, :position, :description, :url).compact_blank.merge(
      id: to_encoded_id,
      children:,
      unselectable:,
    ).compact
  end
end
