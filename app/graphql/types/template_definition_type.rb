# frozen_string_literal: true

module Types
  module TemplateDefinitionType
    include Types::BaseInterface

    field :layout_kind, Types::LayoutKindType, null: false

    field :template_kind, Types::TemplateKindType, null: false
  end
end
