# frozen_string_literal: true

# A validator for the various identifying components of a schema,
# i.e. `namespace` and `identifier`.
#
# @see Schemas::Types::Component
class SchemaComponentValidator < ActiveModel::EachValidator
  # The supported format. Alphanumeric with underscores, all lowercase.
  COMPONENT_FORMAT = ::Schemas::Types::COMPONENT_FORMAT

  private_constant :COMPONENT_FORMAT

  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if COMPONENT_FORMAT.match? value

    record.errors.add attribute, :must_be_schema_component
  end
end
