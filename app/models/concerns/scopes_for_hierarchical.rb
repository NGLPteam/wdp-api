# frozen_string_literal: true

module ScopesForHierarchical
  extend ActiveSupport::Concern

  included do
    scope :for_hierarchical, ->(hierarchical) { recognized_hierarchical_entity?(hierarchical) ? where(hierarchical: hierarchical) : none }
    scope :for_hierarchical_type, ->(hierarchical_type) { where(hierarchical_type: hierarchical_type) }
  end

  module ClassMethods
    def recognized_hierarchical_entity?(value)
      case value
      when HierarchicalEntity then true
      when AppTypes::Array.of(AppTypes.Instance(HierarchicalEntity)) then true
      else
        false
      end
    end
  end
end
