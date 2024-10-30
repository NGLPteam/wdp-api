# frozen_string_literal: true

module Types
  class SchemaComponentType < Types::BaseScalar
    description <<~TEXT
    A string primitive with a very constrained format, representing components
    of a schema like namespaces, identifiers, ordering names, etc.

    It is also used in the templating subsystem.

    It corresponds to the regular expression `#{::Schemas::Types::COMPONENT_FORMAT}`.
    TEXT

    wraps_dry_type! ::Schemas::Types::Component
  end
end
