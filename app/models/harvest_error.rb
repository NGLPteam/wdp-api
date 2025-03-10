# frozen_string_literal: true

# A polymorphic record of harvest errors
class HarvestError < ApplicationRecord
  include TimestampScopes

  belongs_to :source, polymorphic: true

  UNKNOWN_COLLECTIONS = "existing collection with identifier"

  scope :by_code, ->(code) { where(code:) }
  scope :by_source_type, ->(type) { where source_type: type }
  scope :harvest_entities, -> { by_source_type "HarvestEntity" }
  scope :harvest_records, -> { by_source_type "HarvestRecord" }
  scope :maybe_by_code, ->(*codes) do
    codes.flatten!

    by_code(codes) if codes.present?
  end
  scope :message_contains, ->(needle) { where_contains(message: needle) }
  scope :sans_message, ->(needle) { where.not(id: message_contains(needle)) }
  scope :unknown_collections, -> { message_contains(UNKNOWN_COLLECTIONS) }
  scope :sans_unknown_collections, -> { sans_message UNKNOWN_COLLECTIONS }
  scope :with_invalid_parentage, -> { where(arel_json_get_path_as_text(:metadata, "reason", 0).eq("invalid_parentage")) }

  validates :code, :message, presence: true
end
