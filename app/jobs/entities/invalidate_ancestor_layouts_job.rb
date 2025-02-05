# frozen_string_literal: true

module Entities
  class InvalidateAncestorLayoutsJob < ::Entities::AbstractLayoutInvalidationJob
    entity_enumerator_klass Entities::Enumeration::Ancestors
  end
end
