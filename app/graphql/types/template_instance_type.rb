# frozen_string_literal: true

module Types
  module TemplateInstanceType
    include Types::BaseInterface

    implements Types::RenderableType

    field :layout_kind, Types::LayoutKindType, null: false

    field :template_kind, Types::TemplateKindType, null: false
  end
end
