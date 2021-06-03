# frozen_string_literal: true

module HierarchicalEntity
  extend ActiveSupport::Concern

  include HasSystemSlug

  included do
    delegate :auth_path, to: :contextual_parent, allow_nil: true, prefix: :contextual

    before_validation :maybe_update_auth_path!, on: :update
  end

  # @!private
  # @return [String]
  def derive_auth_path
    return unless persisted? && system_slug?

    [contextual_auth_path, system_slug].compact.join(".")
  end

  def contextual_parent
    root? ? hierarchical_parent : parent
  end

  def hierarchical_id
    id
  end

  # @abstract
  def hierarchical_parent
    # :nocov:
    raise NotImplementedError, "Must implement #{self.class}##{__method__}"
    # :nocov:
  end

  def hierarchical_type
    model_name.to_s
  end

  # @!private
  # @return [void]
  def maybe_update_auth_path!
    return unless persisted? && system_slug?

    self.auth_path = derive_auth_path
  end

  def role_prefix
    model_name.collection
  end

  # @return [void]
  def set_system_slug!
    super

    update_column :auth_path, derive_auth_path

    sync_entity!
  end

  # @!private
  # @return [void]
  def sync_entity!
    tuple = to_hierarchical_tuple

    Entity.upsert(tuple, unique_by: %i[hierarchical_type hierarchical_id])
  end

  def to_hierarchical_tuple
    slice(:hierarchical_id, :hierarchical_type, :auth_path, :system_slug, :role_prefix)
  end
end
