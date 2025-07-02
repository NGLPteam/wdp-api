# frozen_string_literal: true

module Rendering
  class LayoutLog < ApplicationRecord
    include HasEphemeralSystemSlug
    include RenderLog
    include TimestampScopes

    belongs_to :schema_version, inverse_of: :rendering_layout_logs

    belongs_to :entity, polymorphic: true, inverse_of: :rendering_layout_logs

    belongs_to :layout_definition, polymorphic: true, inverse_of: :rendering_layout_logs

    pg_enum! :layout_kind, as: :layout_kind, allow_blank: false, suffix: :layout
  end
end
