# frozen_string_literal: true

module ScopesForEntity
  extend ActiveSupport::Concern

  included do
    scope :for_entity, ->(entity) { recognized_entity_entity?(entity) ? where(entity: entity) : none }
    scope :for_entity_type, ->(entity_type) { where(entity_type: entity_type) }
  end

  module ClassMethods
    def recognized_entity_entity?(value)
      case value
      when HierarchicalEntity then true
      when AppTypes::Array.of(AppTypes.Instance(HierarchicalEntity)) then true
      else
        false
      end
    end
  end
end