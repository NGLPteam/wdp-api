# frozen_string_literal: true

class GlobalConfiguration < ApplicationRecord
  attribute :institution, Settings::Institution.to_type
  attribute :site, Settings::Site.to_type
  attribute :theme, Settings::Theme.to_type

  scope :singleton, -> { where(guard: true) }

  validates :guard, presence: true, uniqueness: true

  validates :institution, :site, :theme,
    store_model: true

  class << self
    # @return [GlobalConfiguration]
    def fetch
      GlobalConfiguration.singleton.first_or_create!
    end
  end
end
