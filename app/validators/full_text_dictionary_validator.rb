# frozen_string_literal: true

# A validated for Postgres' full text dictionary fields.
#
# @note The underlying database type is `regconfig`, which Rails treats
#   as a string. This ensures that we are not passing anything that
#   would violate the constraints of that type.
class FullTextDictionaryValidator < ActiveModel::EachValidator
  # These conform to postgres' supported dictionaries for FTS,
  # and are fixed to the version of PG WDP is running against.
  #
  # @see https://www.postgresql.org/docs/13/textsearch-intro.html#TEXTSEARCH-INTRO-CONFIGURATIONS
  SUPPORTED_DICTIONARIES = %w[
    arabic
    danish
    dutch
    english
    finnish
    french
    german
    greek
    hungarian
    indonesian
    irish
    italian
    lithuanian
    nepali
    norwegian
    portuguese
    romanian
    russian
    simple
    spanish
    swedish
    tamil
    turkish
  ].freeze

  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.in? SUPPORTED_DICTIONARIES

    record.errors.add attribute, "must be a supported PostgreSQL full text config"
  end
end
