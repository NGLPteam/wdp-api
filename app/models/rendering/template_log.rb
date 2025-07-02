# frozen_string_literal: true

module Rendering
  class TemplateLog < ApplicationRecord
    include HasEphemeralSystemSlug
    include RenderLog
    include TimestampScopes

    belongs_to :schema_version, inverse_of: :rendering_template_logs

    belongs_to :entity, polymorphic: true, inverse_of: :rendering_template_logs

    belongs_to :layout_definition, polymorphic: true, inverse_of: :rendering_template_logs

    belongs_to :template_definition, polymorphic: true, inverse_of: :rendering_template_logs

    pg_enum! :layout_kind, as: :layout_kind, allow_blank: false, suffix: :layout

    pg_enum! :template_kind, as: :template_kind, allow_blank: false, suffix: :template
  end
end
