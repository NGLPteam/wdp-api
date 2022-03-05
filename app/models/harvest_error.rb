# frozen_string_literal: true

# A polymorphic record of harvest errors
class HarvestError < ApplicationRecord
  belongs_to :source, polymorphic: true

  scope :by_source_type, ->(type) { where source_type: type }
  scope :harvest_entities, -> { by_source_type "HarvestEntity" }
  scope :harvest_records, -> { by_source_type "HarvestRecord" }
  scope :latest_attempt, -> { build_latest_attempt_scope }

  validates :code, :message, presence: true

  class << self
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
