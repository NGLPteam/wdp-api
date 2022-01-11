# frozen_string_literal: true

module EntityChildRecord
  extend ActiveSupport::Concern

  include EntityAdjacentAssociations
  include ReferencesEntityVisibility

  included do
    has_one_entity_adjacent :entity_visibility
  end
end
