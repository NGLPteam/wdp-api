# frozen_string_literal: true

# A validator for the metadata formats currently supported by WDP-API.
class HarvestingMetadataFormatValidator < ActiveModel::EachValidator
  # The currently supported metadata formats.
  SUPPORTED_FORMATS = %w[
    jats
    mods
  ].freeze

  private_constant :SUPPORTED_FORMATS

  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.in? SUPPORTED_FORMATS

    record.errors.add attribute, "must be a supported harvesting metadata format"
  end
end
