# frozen_string_literal: true

module HasCalculatedSystemSlug
  extend ActiveSupport::Concern

  included do
    before_validation :calculate_system_slug!, if: :should_recalculate_system_slug?

    validates :system_slug, presence: true, uniqueness: true
  end

  # @abstract
  # @api private
  # @return [String]
  def calculate_system_slug
    # :nocov:
    raise "Must implement #{self.class}##{__method__}"
    # :nocov:
  end

  # @api private
  # @return [void]
  def calculate_system_slug!
    self.system_slug = calculate_system_slug
  end

  # @abstract
  def should_recalculate_system_slug?
    true
  end
end
