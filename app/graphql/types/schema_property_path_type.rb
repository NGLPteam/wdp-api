# frozen_string_literal: true

module Types
  class SchemaPropertyPathType < Types::BaseScalar
    description <<~TEXT
    A path to a schema property (it will always be a string primitive).

    It can come in the form of a `"single_property"` or a `"nested.property"`.

    This scalar is only used to assert the _format_, it does not
    validate that it is an existing schema property.
    TEXT

    wraps_dry_type! ::Schemas::Properties::Types::FullPath
  end
end
