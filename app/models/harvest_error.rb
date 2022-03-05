# frozen_string_literal: true

# A polymorphic record of harvest errors
class HarvestError < ApplicationRecord
  belongs_to :source, polymorphic: true

  UNKNOWN_COLLECTIONS = "existing collection with identifier"

  scope :by_code, ->(code) { where(code: code) }
  scope :by_source_type, ->(type) { where source_type: type }
  scope :harvest_entities, -> { by_source_type "HarvestEntity" }
  scope :harvest_records, -> { by_source_type "HarvestRecord" }
  scope :latest_attempt, -> { build_latest_attempt_scope }
  scope :message_contains, ->(needle) { where_contains(message: needle) }
  scope :sans_message, ->(needle) { where.not(id: message_contains(needle)) }
  scope :unknown_collections, -> { message_contains(UNKNOWN_COLLECTIONS) }
  scope :sans_unknown_collections, -> { sans_message UNKNOWN_COLLECTIONS }
  scope :with_invalid_parentage, -> { where(arel_json_get_path_as_text(:metadata, "reason", 0).eq("invalid_parentage")) }

  validates :code, :message, presence: true

  class << self
    def latest_message(needle)
      preload(:source).latest_attempt.message_contains(needle)
    end

    # @api private
    # @return [ActiveRecord::Relation<HarvestError>]
    def build_latest_attempt_scope
      from_latest = Arel::Nodes::Case.new(arel_table[:source_type]).tap do |stmt|
        harvest_entities = arel_quote_query HarvestEntity.latest_attempt.select(:id)
        harvest_records = arel_quote_query HarvestRecord.latest_attempt.select(:id)

        stmt.when("HarvestEntity").then(arel_table[:source_id].in(harvest_entities))
        stmt.when("HarvestRecord").then(arel_table[:source_id].in(harvest_records))
        stmt.else(false)
      end

      where from_latest
    end
  end
end
