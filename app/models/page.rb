# frozen_string_literal: true

# An arbitrary page of content associated with a specific {HierarchicalEntity}.
class Page < ApplicationRecord
  include EntityChildRecord
  include ImageUploader::Attachment.new(:hero_image)

  belongs_to :entity, polymorphic: true, inverse_of: :pages

  validates :title, :slug, :body, presence: true

  validates :slug, uniqueness: { scope: %i[entity_type entity_id] }

  acts_as_list scope: :entity, add_new_at: :bottom

  scope :by_slug, ->(slug) { where(slug: slug) }

  scope :in_default_order, -> { order(position: :asc) }
end
