# frozen_string_literal: true

# A logical grouping of records in a {HarvestSource}
class HarvestSet < ApplicationRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  belongs_to :harvest_source, inverse_of: :harvest_sets

  has_many :harvest_attempts, inverse_of: :harvest_set, dependent: :destroy

  has_many :harvest_configurations, inverse_of: :harvest_set, dependent: :nullify

  has_many :harvest_mappings, inverse_of: :harvest_set, dependent: :destroy

  has_many :harvest_set_record_links, inverse_of: :harvest_set, dependent: :delete_all

  has_many :harvest_records, through: :harvest_set_record_links

  scope :in_default_order, -> { lazily_order(:identifier, :asc).lazily_order(:name, :asc) }
  scope :in_inverse_order, -> { lazily_order(:identifier, :desc).lazily_order(:name, :desc) }

  scope :lookup_by_name, ->(name) { where_contains(name:) if name.present? }

  has_many_readonly :latest_harvest_attempt_links, inverse_of: :harvest_set

  scope :by_identifier, ->(identifier) { where(identifier:) }

  validates :identifier, uniqueness: { scope: %i[harvest_source_id] }

  class << self
    # @param [String] raw_value
    # @return [ActiveRecord::Relation<HarvestSet>]
    def lookup_by_prefix(raw_value)
      value = raw_value.to_s.strip

      return all if value.blank?

      where_begins_like(identifier: value, name: value, _or: true).reorder(nil).in_default_order
    end
  end
end
