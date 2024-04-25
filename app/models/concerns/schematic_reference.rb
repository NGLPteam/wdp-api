# frozen_string_literal: true

module SchematicReference
  extend ActiveSupport::Concern

  include SchematicPathValidity

  included do
    belongs_to :referrer, polymorphic: true
    belongs_to :referent, polymorphic: true

    # rubocop:disable Rails/InverseOf
    belongs_to :entity, foreign_key: %i[referrer_type referrer_id], primary_key: %i[entity_type entity_id]
    # rubocop:enable Rails/InverseOf

    has_one :schema_version, through: :entity

    scope :by_referrer, ->(referrer) { where(referrer:) }
    scope :by_referent, ->(referent) { where(referent:) }
    scope :by_path, ->(path) { where(path:) }
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
