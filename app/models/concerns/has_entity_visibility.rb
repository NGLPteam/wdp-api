# frozen_string_literal: true

module HasEntityVisibility
  extend ActiveSupport::Concern

  included do
    pg_enum! :visibility, as: "entity_visibility", _prefix: :visibility

    validate :enforce_range_with_limited_visibility!
    validate :enforce_hidden_visibility!
  end

  # @api private
  # @return [void]
  def enforce_hidden_visibility!
    if visibility_hidden?
      self.hidden_at ||= Time.current
    else
      self.hidden_at = nil
    end
  end

  # @api private
  # @return [void]
  def enforce_range_with_limited_visibility!
    unless visibility_limited?
      self.visible_until_at = nil
      self.visible_after_at = nil

      return
    end

    if visible_after_at? && visible_until_at?
      errors.add :visible_until_at, :before_start if visible_until_at <= visible_after_at
    end

    return if visible_after_at? || visible_until_at?

    errors.add :visibility, :missing_range
  end
end
