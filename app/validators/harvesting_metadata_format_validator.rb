# frozen_string_literal: true

# A validator for the metadata formats currently supported by WDP-API.
class HarvestingMetadataFormatValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if Harvesting::Types::MetadataFormat.valid?(value)

    record.errors.add attribute, "must be a supported harvesting metadata format"
  end
end
