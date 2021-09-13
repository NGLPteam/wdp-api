# frozen_string_literal: true

module MutationOperations
  module UpdatesEntity
    extend ActiveSupport::Concern

    included do
      use_contract! :entity_input
      use_contract! :update_entity_thumbnail
    end

    def update_entity!(entity, thumbnail: nil, clear_thumbnail: false, **attributes)
      entity.assign_attributes attributes

      if thumbnail.present?
        entity.thumbnail = thumbnail
      elsif clear_thumbnail
        entity.thumbnail = nil
      end

      persist_model! entity, attach_to: entity.schema_kind.to_sym
    end
  end
end
