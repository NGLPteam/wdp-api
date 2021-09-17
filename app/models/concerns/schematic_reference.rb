# frozen_string_literal: true

module SchematicReference
  extend ActiveSupport::Concern

  included do
    belongs_to :referrer, polymorphic: true
    belongs_to :referent, polymorphic: true

    scope :by_referrer, ->(referrer) { where(referrer: referrer) }
    scope :by_referent, ->(referent) { where(referent: referent) }
    scope :by_path, ->(path) { where(path: path) }
    scope :to_prune, -> { preload(:referrer, :referent) }
  end

  # @return [void]
  def prune_if_orphaned!
    destroy! if orphaned?
  end

  def orphaned?
    referrer.blank? || referent.blank?
  end
end
