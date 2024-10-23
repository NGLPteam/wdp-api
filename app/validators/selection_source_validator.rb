# frozen_string_literal: true

# Ensure that a given selection source is valid for the template.
class SelectionSourceValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :must_be_selection_source) unless value.present? && value.match?(::Templates::Types::SELECTION_SOURCE_PATTERN)
  end
end
