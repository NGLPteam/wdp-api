# frozen_string_literal: true

# This model controls the visibility of {HierarchicalEntity entities} in a way
# that allows them to be connected with adjacent and supporting models, e.g.
# {EntityAdjacent}, {Entity}, and so on.
#
# At any given point, an entity can be in one of three visibility states, represented
# in the database as an enum:
#
# * `visible` An entity is entirely visible
# * `limited` An entity has some kind of range applied that restricts its availability
#   based on the current time. See {#visible_after_at}, {#visible_until_at}.
# * `hidden` An entity is entirely hidden.
#
# A generated attribute, `visibility_range`, is used to handle checking for limited cases.
class EntityVisibility < ApplicationRecord
  include TimestampScopes

  # When scoping, it only makes sense to scope by `hidden`
  # or `visible` for the specified time.
  ScopableVisibility = AppTypes::Coercible::Symbol.enum(:hidden, :visible)

  pg_enum! :visibility, as: "entity_visibility", prefix: :visibility

  scope :visible_at, ->(time) { build_visibility_scope_for(:visible, at: time) }
  scope :hidden_at, ->(time) { build_visibility_scope_for(:hidden, at: time) }

  scope :currently_visible, -> { visible_at Time.current }
  scope :currently_hidden, -> { hidden_at Time.current }

  validate :enforce_range_with_limited_visibility!
  validate :enforce_hidden_visibility!

  after_save :reload_range!, if: :saved_change_to_visibility?

  def currently_visible?
    visible_as_of? Time.current
  end

  def currently_hidden?
    hidden_as_of? Time.current
  end

  def hidden_as_of?(now = Time.current)
    return false if visibility_visible?

    return true if visibility_hidden?

    !(visible_after?(now) && visible_until?(now))
  end

  def visible_as_of?(now = Time.current)
    return true if visibility_visible?

    return false if visibility_hidden?

    visible_after?(now) && visible_until?(now)
  end

  def visible_after?(now)
    return true if visibility_visible?

    return false if visibility_hidden?

    return true unless visible_after_at?

    visible_after_at < now
  end

  def visible_until?(now)
    return true if visibility_visible?

    return false if visibility_hidden?

    return true unless visible_until_at?

    visible_until_at > now
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

  # @api private
  # @return [void]
  def reload_range!
    reload
  end

  class << self
    # @api private
    # @param [:hidden, :visible] visibility
    # @param [ActiveSupport::TimeWithZone] at
    # @return [ActiveRecord::Relation]
    def build_visibility_scope_for(visibility, at: Time.current)
      visibility = ScopableVisibility[visibility]

      quoted_timestamp = arel_cast(arel_quote(at), "timestamptz")

      range_matches = arel_infix("@>", arel_table[:visibility_range], quoted_timestamp).then do |contains|
        visibility == :hidden ? arel_not(contains) : contains
      end

      case_expr = Arel::Nodes::Case.new(arel_table[:visibility]).tap do |expr|
        expr.when(arel_quote("visible")).then(visibility == :visible)
        expr.when(arel_quote("hidden")).then(visibility == :hidden)
        expr.when(arel_quote("limited")).then(range_matches)
        expr.else(visibility == :hidden)
      end

      where(case_expr)
    end
  end
end
