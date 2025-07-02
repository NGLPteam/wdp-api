# frozen_string_literal: true

module Rendering
  class EntityLog < ApplicationRecord
    include HasEphemeralSystemSlug
    include RenderLog
    include TimestampScopes

    belongs_to :schema_version, inverse_of: :rendering_entity_logs

    belongs_to :entity, polymorphic: true, inverse_of: :rendering_entity_logs
  end
end
