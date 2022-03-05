# frozen_string_literal: true

# A staging ground for an {Item} or a {Collection}, extracted
# from metadata contained within a {HarvestRecord}.
class HarvestEntity < ApplicationRecord
  include HasHarvestErrors
  include ScopesForIdentifier

  has_closure_tree

  belongs_to :harvest_record, inverse_of: :harvest_entities

  belongs_to :entity, polymorphic: true, optional: true

  belongs_to :existing_parent, polymorphic: true, optional: true

  belongs_to :schema_version, optional: true

  has_one :harvest_attempt, through: :harvest_record

  has_many :harvest_contributions, inverse_of: :harvest_entity, dependent: :destroy

  attribute :extracted_assets, Harvesting::Assets::Mapping.to_type, default: proc { {} }
  attribute :extracted_links, Harvesting::Links::Mapping.to_type, default: proc { {} }

  scope :latest_attempt, -> { where(harvest_record_id: HarvestRecord.latest_attempt.select(:id)) }

  scope :filtered_by_schema_version, ->(schemas) { where(schema_version: SchemaVersion.filtered_by(schemas)) }
  scope :by_metadata_kind, ->(kind) { where(metadata_kind: kind) }
  scope :for_metadata_format, ->(metadata_format) { joins(:harvest_record).merge(HarvestRecord.for_metadata_format(metadata_format)) }
  scope :with_jats_format, -> { for_metadata_format "jats" }
  scope :with_mets_format, -> { for_metadata_format "mets" }
  scope :with_mods_format, -> { for_metadata_format "mods" }
  scope :with_extracted_properties, ->(props) { where(arel_json_contains(:extracted_properties, props)) }
  scope :with_existing_parent, ->(parent) { where(existing_parent: parent) }

  validates :identifier, presence: true, uniqueness: { scope: :harvest_record_id }
  validate :exclusive_parentage!

  def has_existing_parent?
    existing_parent_id.present?
  end

  # @return [void]
  def upsert!
    call_operation("harvesting.actions.upsert_entity", self)
  end

  # @param [#as_json] reason
  # @return [(Symbol, String, Hash)]
  def to_failed_upsert(reason = nil)
    metadata = {
      harvest_entity_id: id,
      reason: reason.as_json,
    }

    message = "Could not upsert HarvestEntity(#{id})"

    [:failed_entity_upsert, message, metadata]
  end

  private

  # @return [void]
  def exclusive_parentage!
    errors.add :base, "Child harvest entities cannot have an existing parent set" if !root? && has_existing_parent?
  end
end
