# frozen_string_literal: true

# Global configurations for the entire WDP-API installation.
class GlobalConfiguration < ApplicationRecord
  attribute :institution, Settings::Institution.to_type
  attribute :site, Settings::Site.to_type
  attribute :theme, Settings::Theme.to_type

  scope :singleton, -> { where(guard: true) }

  validates :guard, presence: true, uniqueness: true

  validates :institution, :site, :theme,
    store_model: true

  # @api private
  # @return [void]
  def reset!
    institution.reset!

    site.reset!

    save!
  end

  class << self
    # @return [GlobalConfiguration]
    def fetch
      GlobalConfiguration.singleton.first_or_create!
    end

    # @api private
    # @return [void]
    def reset!
      fetch.reset!
    end
  end
end
