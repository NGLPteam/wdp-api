# frozen_string_literal: true

class ORCIDValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if (value.blank? && options[:allow_blank]) ||
      (value.nil? && options[:allow_nil]) ||
      Contributors::Types::ORCID.try(value).success?

    record.errors.add attribute, :must_be_orcid
  end
end
