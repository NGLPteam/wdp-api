# frozen_string_literal: true

# Global configurations for the entire Meru-API installation.
#
# @see Settings::Entities
# @see Settings::Institution
# @see Settings::Site
# @see Settings::Theme
# @see SiteLogoUploader
class GlobalConfiguration < ApplicationRecord
  include SiteLogoUploader::Attachment.new(:logo)
  include TimestampScopes

  attribute :entities, Settings::Entities.to_type
  attribute :institution, Settings::Institution.to_type
  attribute :site, Settings::Site.to_type
  attribute :theme, Settings::Theme.to_type

  scope :singleton, -> { where(guard: true) }

  validates :guard, presence: true, uniqueness: true

  validates :entities, :institution, :site, :theme, store_model: true

  before_validation :maybe_clear_logo_mode!

  # @api private
  # @return [void]
  def reset!
    entities.reset!

    institution.reset!

    site.reset!

    save!
  end

  private

  # If a logo is set, we should set the logo mode to `with_text` or `sans_text`.
  #
  # If it is not set, logo mode should be `none`.
  # @return [void]
  def maybe_clear_logo_mode!
    if logo.present? && site.logo_none?
      site.logo_mode = :with_text
    elsif logo.blank? && site.logo_mode_set?
      site.logo_mode = :none
    end
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
