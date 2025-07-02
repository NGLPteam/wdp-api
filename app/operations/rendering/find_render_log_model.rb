# frozen_string_literal: true

module Rendering
  class FindRenderLogModel
    include Dry::Monads[:result]

    LAYOUT_INSTANCE_KLASSES = ApplicationRecord.pg_enum_values(:layout_kind).map { "layouts/#{_1}_instance".classify }

    TEMPLATE_INSTANCE_KLASSES = ApplicationRecord.pg_enum_values(:template_kind).map { "templates/#{_1}_instance".classify }

    # @param [Renderable, Class<Renderable>] renderable
    # @return [Dry::Monads::Success(Class)]
    # @return [Dry::Monads::Failure(:unrenderable, Object)]
    def call(renderable)
      case renderable.try(:model_name).try(:to_s)
      when *LAYOUT_INSTANCE_KLASSES
        Success ::Rendering::LayoutLog
      when *TEMPLATE_INSTANCE_KLASSES
        Success ::Rendering::TemplateLog
      when "Community", "Collection", "Item"
        Success ::Rendering::EntityLog
      else
        Failure[:unrenderable, renderable]
      end
    end
  end
end
