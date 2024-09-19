# frozen_string_literal: true

class HarvestMetadataMapping < ApplicationRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  belongs_to :harvest_source, inverse_of: :harvest_metadata_mappings

  belongs_to :target_entity, polymorphic: true

  pg_enum! :field, as: :harvest_metadata_mapping_field, allow_blank: false, prefix: :matching

  validates :pattern, presence: true, uniqueness: { scope: %i[harvest_source_id field] }

  class << self
    def matching(relation: [], title: [], identifier: [])
      conditions = [
        matching_specific(relation, field: :relation),
        matching_specific(title, field: :title),
        matching_specific(identifier, field: :identifier),
      ].compact

      return none if conditions.blank?

      matches = arel_or_expressions(conditions)

      where(matches)
        .includes(:target_entity)
        .order(field: :asc)
    end

    # @see .matching
    # @return [HarvestTarget]
    def matching_one!(...)
      matching(...).only_one!.target_entity
    end

    private

    def matching_specific(*values, field:)
      values.flatten!

      return if values.blank?

      matches_pattern = arel_or_expressions(values) do |value|
        arel_named_fn("normalize_whitespace", value).matches_regexp(arel_table[:pattern], false)
      end

      matches_field = arel_table[:field].eq(field)

      arel_grouping(matches_field.and(matches_pattern))
    end
  end
end
