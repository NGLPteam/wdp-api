# frozen_string_literal: true

module Types
  module TemplateInstanceType
    include Types::BaseInterface

    description <<~TEXT
    Entities within the system have templates associated with schema-specific layouts,
    that can be overridden within the hierarchy for more custom approaches.

    This interface defines the *instance* for one such template and entity,
    derived from an associated `TemplateDefinition`.
    TEXT

    implements Types::RenderableType

    field :entity, Types::AnyEntityType, null: false do
      description <<~TEXT
      The associated entity for this template instance.
      TEXT
    end

    field :layout_kind, Types::LayoutKindType, null: false

    field :template_kind, Types::TemplateKindType, null: false

    field :hidden, Boolean, null: false do
      description <<~TEXT
      Whether this template instance should be hidden based on some logic.

      At present, this only occurs if certain slots are empty.
      TEXT
    end

    load_association! :entity
  end
end
