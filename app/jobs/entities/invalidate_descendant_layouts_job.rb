# frozen_string_literal: true

module Entities
  class InvalidateDescendantLayoutsJob < ::Entities::AbstractLayoutInvalidationJob
    entity_enumerator_klass Entities::Enumeration::Descendants
  end
end
