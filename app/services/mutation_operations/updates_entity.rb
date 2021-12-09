# frozen_string_literal: true

module MutationOperations
  module UpdatesEntity
    extend ActiveSupport::Concern

    included do
      use_contract! :entity_input

      attachment! :hero_image, image: true

      attachment! :thumbnail, image: true
    end

    def update_entity!(entity, **attributes)
      assign_attributes! entity, **attributes

      persist_model! entity, attach_to: entity.schema_kind.to_sym
    end
  end
end
