# frozen_string_literal: true

# An announcement pertaining to a {HierarchicalEntity}.
class Announcement < ApplicationRecord
  include EntityChildRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  belongs_to :entity, polymorphic: true, inverse_of: :announcements

  scope :recent_published, -> { reorder(published_on: :desc) }
  scope :oldest_published, -> { reorder(published_on: :asc) }

  validates :published_on, :header, :teaser, :body, presence: true
end
