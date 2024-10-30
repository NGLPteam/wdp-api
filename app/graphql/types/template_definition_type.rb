# frozen_string_literal: true

module Types
  module TemplateDefinitionType
    include Types::BaseInterface

    description <<~TEXT
    Entities within the system have templates associated with schema-specific layouts,
    that can be overridden within the hierarchy for more custom approaches.

    This interface defines the *definition* for one such template and `layoutDefinition`,
    which controls how associated `TemplateInstance`s are rendered.
    TEXT

    field :layout_kind, Types::LayoutKindType, null: false

    field :template_kind, Types::TemplateKindType, null: false
  end
end
