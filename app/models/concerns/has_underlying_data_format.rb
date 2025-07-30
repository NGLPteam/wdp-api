# frozen_string_literal: true

module HasUnderlyingDataFormat
  extend ActiveSupport::Concern

  include HasHarvestMetadataFormat

  included do
    pg_enum! :underlying_data_format, as: :underlying_data_format, allow_blank: false, prefix: :encoded_with

    before_validation :derive_underlying_data_format!
  end

  # @api private
  # @return [void]
  def derive_underlying_data_format!
    self.underlying_data_format = derived_underlying_data_format
  end

  def valid_json_string?(input)
    return false unless input.kind_of?(String)

    Oj.load(input)
  rescue Oj::Error
    false
  else
    true
  end
end
