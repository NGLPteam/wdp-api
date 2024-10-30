# frozen_string_literal: true

module Types
  class TemplateSelectionSourceType < Types::BaseScalar
    description <<~TEXT
    A string primitive that represents a selection source for a template definition.

    It is used to resolve ordered lists of entities for a given template.

    Values can be things like `"self"` or `ancestors.${name}`, where `name` is the
    associated ancestor name defined in the originating entity's schema.

    ```
    #{::Templates::Types::SELECTION_SOURCE_PATTERN}
    ```
    TEXT

    wraps_dry_type! ::Templates::Types::SelectionSource
  end
end
