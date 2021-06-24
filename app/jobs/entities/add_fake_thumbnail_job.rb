# frozen_string_literal: true

module Entities
  class AddFakeThumbnailJob < ApplicationJob
    queue_as :maintenance

    # @param [Entity, HierarchicalEntity] entity
    # @return [void]
    def perform(entity)
      actual =
        case entity
        when Entity
          entity.entity
        when HierarchicalEntity
          entity
        end

      return if actual.blank?

      WDPAPI::Container["entities.add_fake_thumbnail"].call(actual)
    end
  end
end
