# frozen_string_literal: true

class HarvestingMetadataFormatValidator < ActiveModel::EachValidator
  SUPPORTED_FORMATS = %w[
    jats
    mods
  ].freeze

  def validate_each(record, attribute, value)
    return if value.in? SUPPORTED_FORMATS

    record.errors.add attribute, "must be a supported harvesting metadata format"
  end
end
