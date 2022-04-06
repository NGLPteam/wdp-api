# frozen_string_literal: true

# Ensure `nil` values are always cast to an empty string.
class EnforcedStringValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    record[attribute] = "" if value.nil?
  end
end
